get "/", auth: :person do
  @my_challenges =
    @person
    .challenges
    .active
    .includes(:participants)
    .order(started_at: :desc)

  @other_challenges =
    Challenge.includes(:participants).order(started_at: :desc)

  erb :"root/index"
end
