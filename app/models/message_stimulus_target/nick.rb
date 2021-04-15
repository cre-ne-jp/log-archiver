module MessageStimulusTarget
  module Nick
    # Stimulus用のtarget値
    # @return [Symbol]
    # @todo Decoratorを用意して、そちらに移したい。
    def stimulus_target
      :nickMessage
    end
  end
end
