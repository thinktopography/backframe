module Backframe
  module Mime
    extend self

    def register_types
      ::Mime::Type.register('text/tab-separated-values', :tsv)
      ::Mime::Type.register('application/vnd.ms-excel', :xls)
      ::Mime::Type.register('application/vnd.openxmlformats-officedocument.spreadsheetml.sheet', :xlsx)
    end
  end
end
