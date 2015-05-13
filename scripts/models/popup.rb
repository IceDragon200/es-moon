module ES
  class PopupSequenceFrame < Moon::DataModel::Metal
    field :index, type: Integer, allow_nil: true
    field :ox,    type: Integer, allow_nil: true
    field :oy,    type: Integer, allow_nil: true
    field :x,     type: Integer, allow_nil: true
    field :y,     type: Integer, allow_nil: true
    field :angle, type: Integer, allow_nil: true
  end

  class Popup < Moon::DataModel::Metal
    field :name,        type: String,  default: ""
    field :uri,         type: String,  default: ""
    field :filename,    type: String,  default: ""
    field :cell_w,  type: Integer, default: 40
    field :cell_h, type: Integer, default: 40
    field :frame_rate,  type: Integer, default: 16
    array :sequence,    type: PopupSequenceFrame

    alias :__export__ :export

    def export
      data =__export__
      data['sequence'].each do |hsh|
        hsh.keys.each do |key|
          hsh.delete(key) if hsh[key].nil?
        end
      end
      data
    end
  end
end
