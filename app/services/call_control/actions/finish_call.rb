module CallControl::Actions
  class FinishCall < Command
    def valid? event, call
      not call.finished?
    end
  end
end
