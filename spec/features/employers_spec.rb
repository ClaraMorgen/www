require "rails_helper"

RSpec.describe "Employers", type: :feature do
  it 'displays the form as a modal' do
    visit "/employers"
    within('#employer-form-modal') do
      expect(page).to have_content('What are you looking for?') # async
      expect(page).to have_content('In which city(ies) would you like to meet our community ?') # async
      expect(page).to have_content("Why do you want to recruit Le Wagon's alumni?") # async
    end
  end

  it 'notifies Slack if every field is filled' do
    visit "/employers"
    within('#employer-form-modal') do
      fill_in 'First Name', with: 'John'
      fill_in 'Last Name', with: 'Doe'
      fill_in 'Email', with: 'john@doe.comn'
      fill_in 'Phone Number', with: '34567898756'
      fill_in 'Company', with: 'E Corp'
      fill_in 'Website', with: 'www.ecorp.com'
      check('Front-end developer')
      check('Technical Sales')
      check('Paris')
      check('Tokyo')
      check('London')
      fill_in "Why do you want to recruit Le Wagon's alumni?", with: 'Lorem ipsum dolor sit amet, consectetur adipisicing elit. Mollitia expedita obcaecati explicabo minima facilis iste ullam, fuga id quod, quisquam. Aliquam in animi tempora numquam, dicta accusamus quam aperiam, ab.'
      click_button "Join our Hiring Network"
    end
    expect(page).to have_content("Thank you for joining Le Wagon's network.")
  end

  it 'is not working if one field is not filled' do
    visit "/employers"
    within('#employer-form-modal') do
      fill_in 'First Name', with: 'John'
      # missing Last Name
      fill_in 'Email', with: 'john@doe.comn'
      fill_in 'Phone Number', with: '34567898756'
      fill_in 'Company', with: 'E Corp'
      fill_in 'Website', with: 'www.ecorp.com'
      # missing Job Titles checkboxes
      check('Paris')
      check('Tokyo')
      check('London')
      fill_in "Why do you want to recruit Le Wagon's alumni?", with: 'Lorem ipsum dolor sit amet, consectetur adipisicing elit. Mollitia expedita obcaecati explicabo minima facilis iste ullam, fuga id quod, quisquam. Aliquam in animi tempora numquam, dicta accusamus quam aperiam, ab.'
      click_button "Join our Hiring Network"
    end
    expect(page).to have_content("can't be blank")
    expect(page).to_not have_content("Thank you for joining Le Wagon's network.")
  end
end
