class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :find_question, only: [:create, :new, :destroy]  
  before_action :find_answer, only: [:destroy]

  def new
    @answer = @question.answers.new
  end

  def create
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user

    if @answer.save
      flash[:success] = 'Ваш ответ сохранён!'
      redirect_to @question
    else
      flash.now[:danger] = 'Ошибка! Не удалось сохранить Ваш ответ!'
      render :new
    end
  end

  def destroy
    if @answer.user == current_user
      @answer.destroy ? flash[:warning] = 'Ваш ответ удалён!' : flash.now[:danger] = 'Ошибка! Не удалось удалить Ваш ответ!'
    end
    redirect_to @question
  end

  private

    def find_question
      @question = Question.find(params[:question_id])
    end

    def find_answer
      @answer = Answer.find(params[:id])
    end

    def answer_params
      params.require(:answer).permit(:body)
    end
end
