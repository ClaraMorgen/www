city_constraint = Proc.new do |req|
  city = req.params[:city]
  city.blank? || city.match(/^(#{Kitt::Client.query(City::GroupsQuery).data.cities.map { |city| city.slug }.join("|")})$/i)
end

Rails.application.routes.draw do
  mount Attachinary::Engine => "/attachinary"

  get "/proxy/image", to: 'proxy#image', as: :proxy_image

  devise_for :users, controllers: { omniauth_callbacks: "users/omniauth_callbacks" }

  namespace :admin do
    resources :lives, except: [ :index, :destroy ] do
      member do
        patch 'on'
        patch 'off'
      end
    end
    root 'lives#index'
    delete '/log_out', to: 'base#log_out'
  end

  resources :employers, only: [:create], as: :hiring_partners

  resources :prospects, only: :create

  # config/static_routes.yml
  STATIC_ROUTES.each do |template, locale_paths|
    locale_paths.each do |locale, page|
      get page => "pages##{template}", template: template, locale: locale.to_sym, as: "#{template}_#{locale.to_s.underscore}".to_sym
    end
  end

  # Redirects
  get 'premiere', to: redirect('programme')
  get 'marseille', to: redirect('aix-marseille')
  get 'sp', to: redirect('pt-BR/sao-paulo')
  get 'bh', to: redirect('pt-BR/belo-horizonte')
  get 'en', to: redirect('/')
  get 'learn(/:city)', to: redirect { |params, _| params[:city].blank? ? 'learn-to-code' : "learn-to-code/#{params[:city]}" }, as: :learn_to_code
  get 'stories', to: redirect('alumni')
  get 'fr/stories', to: redirect('fr/alumni')
  get 'en/*path', to: redirect { |path_params, req| path_params[:path] }

  react_exceptions = ["pt-BR", "zh-CN", "es", "ja"]
  react_exceptions.each do | exception |
    get "#{exception.to_s}/react", to: redirect("/react")
  end


  get 'ondemand/*path', to: redirect { |path_params, req| "https://ondemand.lewagon.com/#{req.fullpath.gsub("/ondemand/", "")}" }
  get 'codingstationparis', to: redirect('https://www.meetup.com/fr-FR/Le-Wagon-Paris-Coding-Station')

  {
    'davidverbustel' => 'david-joins-efounders',
    'oliviergodement' => 'olivier-joined-stripe-as-user-ops-lead',
    'amontcoudiol' => 'adrien-and-max-reinvent-tv',
    'olixier' => 'seeding-one-million-with-kudoz',
    'aliceclv' => 'alice-joins-save-as-backend-dev'
  }.each do |github_nickname, new_slug|
    ['', 'fr/'].each do |locale|
      get "#{locale.to_s.underscore}stories/#{github_nickname}", to: redirect("#{locale.to_s.underscore}stories/#{new_slug}")
    end
  end

  constraints(city_constraint) do
    get "apply/(:city)" => "applies#new", locale: :en, as: :apply_en
    get "postuler/(:city)" => "applies#new", locale: :fr, as: :apply_fr
    get "candidatar/(:city)" => "applies#new", locale: :"pt-BR", as: :apply_pt_br
    get "postularse/(:city)" => "applies#new", locale: :es, as: :apply_es
    get "申请/(:city)" => "applies#new", locale: :"zh-CN", as: :apply_zh_cn
    get "アプライ/(:city)" => "applies#new", locale: :ja, as: :apply_ja
    post "apply/(:city)" => "applies#create", as: :apply
    post "apply/validate" => "applies#validate", as: :validate_apply
  end

  get "blog/rss", to: 'posts#rss', defaults: { format: :xml }, as: :rss

  get "hec", to: 'applies#new_hec', as: :new_hec_apply
  post "hec", to: 'applies#create_hec', as: :hec_apply, locale: :fr

  scope "(:locale)", locale: /fr|pt-BR|zh-CN|es|ja/ do
    root to: "pages#home"
    get "faq", to: "pages#show", template: "faq", as: :faq
    get "jobs", to: "pages#show", template: "jobs", as: :jobs
    get "stack", to: "pages#stack", template: "stack", as: :stack
    get "employers", to: "pages#employers", template: "employers", as: :employers
    get "learn-to-code(/:city)", to: "pages#learn", template: "learn", as: :learn
    get "enterprise", to: "pages#enterprise", template: "enterprise", as: :enterprise
    get "blog/videos", to: "posts#videos", template: "videos", as: :videos
    get "blog/all", to: "posts#all", template: "all", as: :all
    get "alumni" => "students#index", as: :alumni
    get "projects" => "projects#index", as: :projects
    get "blog", to: 'posts#index', as: :blog
    get "blog/:slug", to: 'posts#show', as: :post
    get "live", to: 'pages#live', as: :live
    get "shop" => "pages#shop", as: :shop
    get "vae" => "pages#vae", as: :vae
    get "cgv" => "pages#cgv", as: :cgv
    get "react" => "pages#react", locale: :en, as: :react
    get "lemoisducode" => "pages#lemoisducode", as: :lemoisducode
    get "partners" => "pages#partners", as: :partners

    constraints(city_constraint) do
      get ":city" => "cities#show", as: :city
    end
    resources :projects, only: [:show]
    resources :stories, only: [:show]
    resources :students, only: [:show]
    resources :demoday, only: [:index, :show] do
      member do
        get "*product_slug", to: 'demoday#show', as: :with_slug
      end
    end
  end

  resources :subscribes, only: :create

  # API
  resource :cache, only: :destroy

  # SEO
  get 'robots', to: 'pages#robots'

  # Old
  get 'wagon_bar', to: redirect('/fr')

  # Linkedin Token
  get 'linkedin', to: 'pages#linkedin'

  # Sidekiq
  require "sidekiq/web"
  require "sidekiq/cron/web"
  authenticate :user do
    mount Sidekiq::Web => '/sidekiq'
  end

  match "/404" => "application#render_404", via: :all
end

# Create helper for static_routes
Rails.application.routes.url_helpers.module_eval do
  STATIC_ROUTES.each do |route, _|
    define_method "#{route}_path".to_sym do |args = {}|
      locale = args[:locale] || :fr
      self.send(:"#{route}_#{locale.to_s.underscore}_path")
    end

    define_method "#{route}_url".to_sym do |args = {}|
      locale = args[:locale] || :fr
      self.send(:"#{route}_#{locale.to_s.underscore}_url")
    end
  end
end
