require 'sinatra/base'

module StatesList
  @all = {
    Select: '',
    AL: 'Alabama',
    AK: 'Alaska',
    AZ: 'Arizona',
    AR: 'Arkansas',
    CA: 'California',
    CO: 'Colorado',
    CT: 'Connecticut',
    DE: 'Delaware',
    FL: 'Florida',
    GA: 'Georgia',
    HI: 'Hawaii',
    ID: 'Idaho',
    IL: 'Illinois',
    IN: 'Indiana',
    IA: 'Iowa',
    KS: 'Kansas',
    KY: 'Kentucky',
    LA: 'Louisiana',
    ME: 'Maine',
    MD: 'Maryland',
    MA: 'Massachusetts',
    MI: 'Michigan',
    MN: 'Minnesota',
    MS: 'Mississippi',
    MO: 'Missouri',
    MT: 'Montana',
    NE: 'Nebraska',
    NV: 'Nevada',
    NH: 'New Hampshire',
    NJ: 'New Jersey',
    NM: 'New Mexico',
    NY: 'New York',
    NC: 'North Carolina',
    ND: 'North Dakota',
    OH: 'Ohio',
    OK: 'Oklahoma',
    OR: 'Oregon',
    PA: 'Pennsylvania',
    RI: 'Rhode Island',
    SC: 'South Carolina',
    SD: 'South Dakota',
    TN: 'Tennessee',
    TX: 'Texas',
    UT: 'Utah',
    VT: 'Vermont',
    VA: 'Virginia',
    WA: 'Washington',
    WV: 'West Virginia',
    WI: 'Wisconsin',
    WY: 'Wyoming'
  }

  def h(str)
    Rack::Utils.escape_html(str)
  end

  def to_select
    all.map { |code, name| [name, code.to_s] }
  end

  def to_options
    select_options to_select
  end

  def [](code)
    all[code.to_sym]  if not code.to_s.empty?
  end

  def all
    @all
  end

  def select_options(pairs, current = nil, prompt = nil)
    pairs.unshift([prompt, '']) if prompt

    pairs.map { |label, value|
      tag(:option, label, :value => value, :selected => (current == value))
    }.join("\n")
  end

  # Builds a tag.
  def tag(tag, content, atts = {})
    if self_closing?(tag)
      %(<#{ tag }#{ tag_attributes(atts) } />)
    else
      %(<#{ tag }#{ tag_attributes(atts) }>#{h content}</#{ tag }>)
    end
  end

  def tag_attributes(atts = {})
    atts.inject([]) { |a, (k, v)|
      a << (' %s="%s"' % [k, escape_attr(v)]) if v
      a
    }.join('')
  end

  def escape_attr(str)
    str.to_s.gsub("'", "&#39;").gsub('"', "&quot;")
  end

  def self_closing?(tag)
    @self_closing ||= [:area, :base, :basefont, :br, :hr,
                       :input, :img, :link, :meta]

    @self_closing.include?(tag.to_sym)
  end

  module_function :all, :to_select, :[], :tag, :tag_attributes, :escape_attr, :self_closing?, :select_options, :to_options, :h
end

register StatesList
