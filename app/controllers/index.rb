get '/' do
  @surveys = Survey.all
  erb :index
end

get '/surveys/:id' do

  @survey = Survey.find(params[:id])
  erb :single_survey

end

post '/submit_responses/:survey_id' do
  Completion.create!(survey_id: params[:survey_id], user_id: 1)
  params.values[0..-4].each do |option_id|
  # above line is hackey, but this is because params[-3] is "splat"=>[], params[-2] is "captures"=>["3"], params[-1] is "survey_id"=>"3"
    Response.create!(user_id: 1, option_id: option_id)
  end
  redirect '/'
end

get '/surveys/:survey_id/responses' do
  "Number of completions for survey " + params[:survey_id] + ": #{Survey.find(params[:survey_id]).completions.count}"
end

get '/survey/new' do
  erb :create_survey
end

post '/create_survey' do
  p params.inspect
  survey_name = params.shift[1]
  survey = Survey.create(name: survey_name)

  while kvp = params.shift do
    if kvp[0].start_with? "question"
      survey.questions << latest_question = Question.create(text: kvp[1])
    else
      latest_question.options << Option.create(text: kvp[1])
    end
  end
  redirect '/'
end
