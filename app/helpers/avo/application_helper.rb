module Avo
  module ApplicationHelper
    include ::Webpacker::Helper
    include ::Pagy::Frontend

    def current_webpacker_instance
      Avo.webpacker
    end

    def render_logo
      render partial: 'vendor/avo/partials/logo' rescue render partial: 'avo/partials/logo'
    end

    def render_header
      render partial: 'vendor/avo/partials/header' rescue render partial: 'avo/partials/header'
    end

    def render_footer
      render partial: 'vendor/avo/partials/footer' rescue render partial: 'avo/partials/footer'
    end

    def render_scripts
      render partial: 'vendor/avo/partials/scripts' rescue ''
    end

    def sidebar_link(label, link, **options)
      active = options[:active].present? ? options[:active] : :inclusive

      render partial: 'avo/sidebar/sidebar_link', locals: {
        label: label,
        link: link,
        active: active,
        options: options
      }
    end

    def render_license_warnings
      render partial: 'avo/sidebar/license_warnings', locals: {
        license: Avo::App.license.properties,
      }
    end

    def render_license_warning(title: '', message: '', icon: 'exclamation')
      render partial: 'avo/sidebar/license_warning', locals: {
        title: title,
        message: message,
        icon: icon,
      }
    end

    def panel(**args, &block)
      render(Avo::PanelComponent.new(**args)) do |component|
        capture(component, &block)
      end
    end

    def modal(&block)
      render layout: 'layouts/avo/modal' do
        capture(&block)
      end
    end

    def empty_state(resource_name)
      render partial: 'avo/partials/empty_state', locals: { resource_name: resource_name }
    end

    def turbo_frame_start(name)
      "<turbo-frame id=\"#{name}\">".html_safe if name.present?
    end

    def turbo_frame_end(name)
      '</turbo-frame>'.html_safe if name.present?
    end

    def a_button(label = nil, **args, &block)
      args[:class] = button_classes(args[:class], color: args[:color], variant: args[:variant], size: args[:size])

      locals = {
        label: label,
        args: args,
      }

      if block_given?
        render layout: 'avo/partials/a_button', locals: locals do
          capture(&block)
        end
      else
        render partial: 'avo/partials/a_button', locals: locals
      end
    end

    def a_link(label, url = nil, **args, &block)
      args[:class] = button_classes(args[:class], color: args[:color], variant: args[:variant], size: args[:size])

      if block_given?
        url = label
      end

      locals = {
        label: label,
        url: url,
        args: args,
      }

      if block_given?
        render layout: 'avo/partials/a_link', locals: locals do
          capture(&block)
        end
      else
        render partial: 'avo/partials/a_link', locals: locals
      end
    end

    def button_classes(extra_classes = nil, color: nil, variant: nil, size: :md)
      classes = "inline-flex flex-grow-0 items-center text-sm font-bold leading-none fill-current whitespace-no-wrap transition duration-100 rounded-lg shadow-xl transform transition duration-100 active:translate-x-px active:translate-y-px cursor-pointer disabled:cursor-not-allowed #{extra_classes}"

      if color.present?
        if variant.present? and variant.to_sym == :outlined
          classes += ' bg-white border'

          classes += " hover:border-#{color}-800 border-#{color}-600 text-#{color}-600 hover:text-#{color}-800 disabled:border-gray-300 disabled:text-gray-600"
        else
          classes += " text-white bg-#{color}-500 hover:bg-#{color}-600 disabled:bg-#{color}-300"
        end
      else
        classes += ' text-gray-800 bg-white hover:bg-gray-100 disabled:bg-gray-300'
      end

      size = size.present? ? size.to_sym : :md
      case size
      when :xs
        classes += ' p-2 py-1'
      when :sm
        classes += ' p-3'
      when :md
        classes += ' p-4'
      else
        classes += ' p-4'
      end

      classes
    end

    def svg(path, **args)
      classes = args[:class].present? ? args[:class] : 'h-4 mr-1'
      classes += args[:extra_class].present? ? " #{args[:extra_class]}" : ''

      inline_svg_pack_tag path, **args, class: classes
    end

    def input_classes(extra_classes = '', has_error: false)
      classes = 'appearance-none inline-flex bg-gray-200 disabled:bg-gray-400 disabled:cursor-not-allowed focus:bg-white text-gray-700 disabled:text-gray-600 rounded-md py-2 px-3 leading-tight border outline-none outline'

      if has_error
        classes += ' border-red-600 focus:border-red-700'
      else
        classes += ' border-gray-300 focus:border-gray-400'
      end

      classes += " #{extra_classes}"

      classes
    end
  end
end
