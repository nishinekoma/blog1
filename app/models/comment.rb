class Comment < ApplicationRecord
    include Visible

    belongs_to :article #一つの記事に複数のコメントが従属する。
    
end
