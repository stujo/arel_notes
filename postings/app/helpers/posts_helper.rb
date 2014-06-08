module PostsHelper

  def visibility_display post
    post.public ? "shared by #{post.user.email}" : 'private (yours)'
  end

end
