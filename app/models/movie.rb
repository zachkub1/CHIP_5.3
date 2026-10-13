class Movie < ApplicationRecord
  def self.all_ratings
    %w[G PG PG-13 R]
  end

  def self.with_ratings(ratings_list)
    # if ratings_list is an array such as ['G', 'PG', 'R'], retrieve all
    #  movies with those ratings
    # if ratings_list is nil, retrieve ALL movies
    return all if ratings_list.blank?

    where("UPPER(rating) IN (?)", ratings_list.map { |r| r.to_s.upcase })
  end
end
