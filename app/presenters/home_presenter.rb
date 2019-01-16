class HomePresenter
    attr_accessor :institutions
    
    def initialize()
      @institutions = Institutions.all
    end
  end
  