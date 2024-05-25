class Article < ApplicationRecord
    validates :title, presence: true #validatesにより登録時にこれらの情報がある必要がる。https://guides.rubyonrails.org/active_record_validations.html
    validates :body, presence: true, length: { minimum: 10 }
  end