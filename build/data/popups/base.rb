require_relative '../sequence_builder'

def render_popup_sequence(&block)
  render_sequence(ES::DataModel::PopupSequenceFrame, &block)
end
