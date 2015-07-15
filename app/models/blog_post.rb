class BlogPost < ActiveRecord::Base

  def self.update
    # JSON holen
    response = Net::HTTP.get_response(URI.parse("http://blog.speakerinnen.org/export.json"))
    # parsen
    imported_posts = JSON.parse(response.body)

    # BlogPost in db packen
    imported_posts[0..3].reverse.each do |post|
      BlogPost.create(title: post['title'], body: post['body'], url: post['url'])
    end

    # remove old inports to make sure the db is not full of old useless stuff
    # check if this offset thing works as we think
    BlogPost.order('created_at DESC').offset(30).all.each do |post|
      post.destroy
    end
  end

end
