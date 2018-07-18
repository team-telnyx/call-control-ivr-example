module CallControl::Actions
  class CreateCall < Command
    def execute event, call
      call = create_call(event) if call.nil?
    end

    def load_call event
      super
    rescue ActiveRecord::RecordNotFound
      nil
    end

    private
    def create_call event
      call = ::Call.build(event)
      call.save!
      call
    end
  end
end
