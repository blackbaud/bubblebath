module Bubblebath

  class Bubblebath::BubblebathError < RuntimeError; end

  class Bubblebath::MatcherNotFound < RuntimeError ;end
  class Bubblebath::TestError < RuntimeError ;end
  class Bubblebath::TestFailure < RuntimeError ;end
  class Bubblebath::PostFailure < RuntimeError ;end
  class Bubblebath::SecurityIssue < RuntimeError; end
  class Bubblebath::ModelNotFound < RuntimeError ;end
  class Bubblebath::ModelCreationError < RuntimeError ;end
  class Bubblebath::InvalidConfigurationFile < Bubblebath::BubblebathError ;end
  class Bubblebath::VerificationException < RuntimeError
    attr_accessor :actual, :expected
  end

  class Bubblebath::SchemaComplianceError < Bubblebath::BubblebathError
    def initialize(error_arrays)
      @errors = error_arrays
    end

    def message
      @errors
    end
  end

end