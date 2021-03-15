module MessageStimulusTarget
  module Speech
    # Stimulus用のtarget値
    # @return [Symbol]
    # @todo Decoratorを用意して、そちらに移したい。
    def stimulus_target
      :speechMessage
    end
  end
end
