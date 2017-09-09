class MxCheckerService

  def collect_mx_records(domains)
    return unless domains.is_a? Array
    domains.each_with_object(Hash.new) do |domain, acc|
      acc[domain] = mx(domain)
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
