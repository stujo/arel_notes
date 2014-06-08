    <h1 class="page-heading">AREL Rails 4 Notes</h1>

    <p>AREL is a database agnostic object and collection modelling toolkit</p>

    <p>When you need more than .where(), you don't need to write SQL because you can use AREL</p>

    <p>The example I'm thinking about is when I want a user a list of Things, the Pseudo query might
        be something along the lines of:</p>

<pre class="prettyprint lang-sql">
SELECT all the posts which are public or were authored by the current user
</pre>

    <p>I can't see a way to do this using .where({hash}) and I'd rather avoid putting a SQL statement directly:</p>

<pre class="prettyprint lang-rb">
class PostsController

    def index
        @posts = Post.where("user_id = ? OR public = true", current_user.id)
    end

end
</pre>

    <p>This is where AREL can help!</p>

    <p>I think it's a good idea to encapsulate the logic into the model class, and I like the idea of making this into
        a scope so that we can use additional filtering and pagination later on without refactoring the query</p>

<pre class="prettyprint lang-rb">

class Post < ActiveRecord::Base
  belongs_to :user

  def visible_to user
    self.public || self.user == user
  end

  def editable_by user
    self.user == user
  end

  def self.visible_to user
    self.where self.arel_visible_to(user)
  end

  private

  def self.arel_owned_by user
    arel_table[:user_id].eq(user.id)
  end

  def self.arel_public
    arel_table[:public].eq(true)
  end

  def self.arel_visible_to user
    if user.nil?
      self.arel_public
    else
      self.arel_owned_by(user).or(self.arel_public)
    end
  end
end



class PostsController

    def index
        @posts = Post.visible_to current_user
    end

    ...
end
</pre>

This cause 1 + N queries (if we use the user in the view), but using this technique we can join the user table nicely:

<pre>
class PostsController

  def index
    @posts = Post.visible_to(current_user).includes(:user)
  end

    ...
end
</pre>

<pre>
Started GET "/" for 127.0.0.1 at 2014-06-07 18:51:41 -0700
  ActiveRecord::SchemaMigration Load (0.3ms)  SELECT "schema_migrations".* FROM "schema_migrations"
Processing by PostsController#index as HTML
  User Load (0.7ms)  SELECT  "users".* FROM "users"  WHERE "users"."id" = 1  ORDER BY "users"."id" ASC LIMIT 1
  Post Load (0.4ms)  SELECT "posts".* FROM "posts"  WHERE "posts"."public" = 't'
  User Load (0.5ms)  SELECT "users".* FROM "users"  WHERE "users"."id" IN (3, 1, 2)
  Rendered posts/index.html.erb within layouts/application (21.0ms)
Completed 200 OK in 182ms (Views: 142.7ms | ActiveRecord: 4.1ms)
</pre>

    <div class="panel panel-default">
        <div class="panel-heading">Resources</div>
        <div class="panel-body">
            <ul>
                <li><a href="https://github.com/rails/arel">rails/arel</a></li>
                <li><a href="http://robots.thoughtbot.com/using-arel-to-compose-sql-queries">thoughtbot - AREL for SQL
                    Queries</a></li>
            </ul>
        </div>
    </div>
