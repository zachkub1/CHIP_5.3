class MoviesController < ApplicationController
  SORT_COLUMNS = %w[title release_date].freeze

  before_action :set_movie, only: %i[ show edit update destroy ]

  # GET /movies or /movies.json
  def index
    if params[:ratings].nil? && params[:sort_by].nil?
      # Landed without sorting/filtering params: restore remembered settings
      if session[:ratings].present? || session[:sort_by].present?
        redirect_to movies_path(ratings: session[:ratings]&.index_with { "1" },
                                sort_by: session[:sort_by]) and return
      end
    else
      session[:ratings] = params[:ratings].respond_to?(:keys) ? params[:ratings].keys : nil
      session[:sort_by] = SORT_COLUMNS.include?(params[:sort_by]) ? params[:sort_by] : nil
    end

    @all_ratings = Movie.all_ratings
    selected = session[:ratings]
    @ratings_to_show = selected.presence || @all_ratings
    @sort_by = session[:sort_by]
    @movies = Movie.with_ratings(selected)
    @movies = @movies.order(@sort_by) if @sort_by
  end

  # GET /movies/1 or /movies/1.json
  def show
  end

  # GET /movies/new
  def new
    @movie = Movie.new
  end

  # GET /movies/1/edit
  def edit
  end

  # POST /movies or /movies.json
  def create
    @movie = Movie.new(movie_params)

    respond_to do |format|
      if @movie.save
        format.html { redirect_to @movie, notice: "Movie was successfully created." }
        format.json { render :show, status: :created, location: @movie }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @movie.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /movies/1 or /movies/1.json
  def update
    respond_to do |format|
      if @movie.update(movie_params)
        format.html { redirect_to @movie, notice: "Movie was successfully updated." }
        format.json { render :show, status: :ok, location: @movie }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @movie.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /movies/1 or /movies/1.json
  def destroy
    @movie.destroy!

    respond_to do |format|
      format.html { redirect_to movies_path, status: :see_other, notice: "Movie was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_movie
      @movie = Movie.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def movie_params
      params.require(:movie).permit(:title, :rating, :description, :release_date)
    end
end
