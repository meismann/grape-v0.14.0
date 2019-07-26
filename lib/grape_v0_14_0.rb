require 'logger'
require 'rack'
require 'rack/mount'
require 'rack/builder'
require 'rack/accept'
require 'rack/auth/basic'
require 'rack/auth/digest/md5'
require 'hashie'
require 'set'
require 'active_support/version'
require 'active_support/core_ext/hash/indifferent_access'
require 'active_support/core_ext/object/blank'
require 'active_support/core_ext/array/extract_options'
require 'active_support/core_ext/array/wrap'
require 'active_support/core_ext/hash/deep_merge'
require 'active_support/core_ext/hash/reverse_merge'
require 'active_support/core_ext/hash/except'
require 'active_support/dependencies/autoload'
require 'active_support/notifications'
require 'multi_json'
require 'multi_xml'
require 'i18n'
require 'thread'

require 'virtus'

I18n.load_path << File.expand_path('../grape_v0_14_0/locale/en.yml', __FILE__)

module GrapeV0_14_0
  extend ActiveSupport::Autoload

  eager_autoload do
    autoload :API
    autoload :Endpoint

    autoload :Route
    autoload :Namespace

    autoload :Path

    autoload :Cookies
    autoload :Validations
    autoload :Request
    autoload :Env, 'grape_v0_14_0/util/env'
  end

  module Http
    extend ActiveSupport::Autoload
    eager_autoload do
      autoload :Headers
    end
  end

  module Exceptions
    extend ActiveSupport::Autoload
    autoload :Base
    autoload :Validation
    autoload :ValidationErrors
    autoload :MissingVendorOption
    autoload :MissingMimeType
    autoload :MissingOption
    autoload :InvalidFormatter
    autoload :InvalidVersionerOption
    autoload :UnknownValidator
    autoload :UnknownOptions
    autoload :UnknownParameter
    autoload :InvalidWithOptionForRepresent
    autoload :IncompatibleOptionValues
    autoload :MissingGroupTypeError,          'grape_v0_14_0/exceptions/missing_group_type'
    autoload :UnsupportedGroupTypeError,      'grape_v0_14_0/exceptions/unsupported_group_type'
    autoload :InvalidMessageBody
    autoload :InvalidAcceptHeader
    autoload :InvalidVersionHeader
  end

  module ErrorFormatter
    extend ActiveSupport::Autoload
    autoload :Base
    autoload :Json
    autoload :Txt
    autoload :Xml
  end

  module Formatter
    extend ActiveSupport::Autoload
    autoload :Base
    autoload :Json
    autoload :SerializableHash
    autoload :Txt
    autoload :Xml
  end

  module Parser
    extend ActiveSupport::Autoload
    autoload :Base
    autoload :Json
    autoload :Xml
  end

  module Middleware
    extend ActiveSupport::Autoload
    autoload :Base
    autoload :Versioner
    autoload :Formatter
    autoload :Error
    autoload :Globals

    module Auth
      extend ActiveSupport::Autoload
      autoload :Base
      autoload :DSL
      autoload :StrategyInfo
      autoload :Strategies
    end

    module Versioner
      extend ActiveSupport::Autoload
      autoload :Path
      autoload :Header
      autoload :Param
      autoload :AcceptVersionHeader
    end
  end

  module Util
    extend ActiveSupport::Autoload
    autoload :InheritableValues
    autoload :StackableValues
    autoload :InheritableSetting
    autoload :StrictHashConfiguration
    autoload :FileResponse
  end

  module DSL
    extend ActiveSupport::Autoload
    eager_autoload do
      autoload :API
      autoload :Callbacks
      autoload :Settings
      autoload :Configuration
      autoload :InsideRoute
      autoload :Helpers
      autoload :Middleware
      autoload :Parameters
      autoload :RequestResponse
      autoload :Routing
      autoload :Validations
    end
  end

  class API
    extend ActiveSupport::Autoload
    autoload :Helpers
  end

  module Presenters
    extend ActiveSupport::Autoload
    autoload :Presenter
  end
end

require 'grape_v0_14_0/util/content_types'

require 'grape_v0_14_0/validations/validators/base'
require 'grape_v0_14_0/validations/attributes_iterator'
require 'grape_v0_14_0/validations/validators/allow_blank'
require 'grape_v0_14_0/validations/validators/at_least_one_of'
require 'grape_v0_14_0/validations/validators/coerce'
require 'grape_v0_14_0/validations/validators/default'
require 'grape_v0_14_0/validations/validators/exactly_one_of'
require 'grape_v0_14_0/validations/validators/mutual_exclusion'
require 'grape_v0_14_0/validations/validators/presence'
require 'grape_v0_14_0/validations/validators/regexp'
require 'grape_v0_14_0/validations/validators/values'
require 'grape_v0_14_0/validations/params_scope'
require 'grape_v0_14_0/validations/validators/all_or_none'
require 'grape_v0_14_0/validations/types'

require 'grape_v0_14_0/version'
