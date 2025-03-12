class User < ApplicationRecord
  belongs_to :company

  scope :by_company, -> (identifier) { where(company_id: identifier) if identifier.present? }
  
  # scope :by_username, -> (username) { where('username LIKE ?', username) if username.present? }
  # scope :by_username, -> (username) { where('username ILIKE ?', "%#{username}%") if username.present? }
  scope :by_username, -> (username) { where('LOWER(username) LIKE LOWER(?)', "%#{username}%") if username.present? }

end
