class MxCheckerService
  DEFAULT_DOMAIN_ZONES = %w(com net org ua).freeze

  def initialize
    @domain_zones = DEFAULT_DOMAIN_ZONES
  end

  def add_domain_zones(zones)
    @domain_zones.push(zones)
  end

  def collect_mx_by_company_title(title)
    domains = @domain_zones.each_with_object(Array.new) do |zone, acc|
      acc << "#{title}.#{zone}"
    end
    collect_mx_records(domains).delete_if { |_k,v| v.blank? }
  end

  def collect_mx_records(domains)
    return unless domains.is_a? Array
    domains.each_with_object(Hash.new) do |domain, acc|
      acc[domain] = mx(domain).first
    end
  end

  def mx(domain)
    Resolv::DNS.open do |dns|
      dns.getresources(domain, Resolv::DNS::Resource::IN::MX).map do |r|
        r.exchange.to_s
      end
    end
  end
end
