class Collection
    attr_accessor :id, :ead_id, :title, :abstract, :extent, :repository,
      :institution_name, :institution_id,
      :children_count
  
    def initialize()
      @children_count = 0
    end
end
  
