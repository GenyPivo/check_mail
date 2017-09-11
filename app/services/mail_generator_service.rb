class MailGeneratorService
  SEPARATE_SYM = %w(. - _).freeze

  def initialize(first_name, last_name)
    @first_name = first_name
    @last_name = last_name
  end

  def generate_mail_addresses(domains)
    raise ArgumentError, 'domains param must be an array' unless domains.is_a? Array
    prefixes = generate_prefixes.map(&:join)
    domains.each_with_object(Hash.new) do |domain, acc|
      acc[domain] = Array.new
      prefixes.each do |prefix|
        acc[domain] << "#{prefix.downcase}@#{domain}"
      end
    end
  end

  private

  def generate_prefixes
    first_batch + second_batch
  end

  def first_batch
    names.permutation(2).to_a + [[@first_name]] + [[@last_name]]
  end

  def second_batch
    permutations = names.permutation(2).to_a
    permutations.each_with_object(Array.new) do |names, acc|
      SEPARATE_SYM.each { |sym|  acc << [names[0], sym, names[1]] }
    end
  end

  def names
    [@first_name, @last_name]
  end
end