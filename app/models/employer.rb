class Employer < Struct.new(:first_name, :last_name, :email, :phone_number, :company, :website, :targets, :locations, :message)
  include ActiveModel::Model

  validates :first_name, :last_name, :email, :phone_number, :company, :website, :targets, :locations, :message, presence: true
  validates :email, format: /\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
  validates :website, format: /\A(https?:\/\/)?([\da-z\.-]+)\.([a-z\.]{2,6})([\/\w \.-]*)*\/?\z/

  def self.from_hash(hash)
    obj = self.new
    hash.each {|key,value| obj.send("#{key}=", value)}
    obj
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  def to_slack_message
"*Person:* #{full_name} - #{email} - #{phone_number}
*Company:* #{company}
*Company Website:* #{website}
*Why:* #{message}
*Which city:* #{self.locations.reject { |l| l.empty? }.join(", ")}
*Looking for:* #{self.targets.reject { |l| l.empty? }.join(", ")}"
  end
end
