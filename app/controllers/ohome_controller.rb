class OhomeController < ApplicationController
  def rightindex
    @id=params[:id]
    unless @id=="0"
      @re=Rest.find(@id)
    end
  end
  
  def leftindex
  end
end
