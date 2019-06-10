class HomePresenter < DefaultPresenter
    attr_accessor :institutions

    def initialize()
      super
      @institutions = Institutions.all
    end
  end
