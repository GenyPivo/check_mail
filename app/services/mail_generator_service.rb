class MailGeneratorService
  SEPARATE_SYM = %w(. - _).freeze

  def initialize(first_name, last_name)
    @first_name = first_name
    @last_name = last_name
    @domain_zones = DEFAULT_DOMAIN_ZONES
  end

  def generate_prefixes
    first_iteration = build_from_batch(first_batch)
    second_iteration = build_from_batch(second_batch)
    first_iteration.each_with_object(Hash.new) do |(k,v), acc|
      acc[k] = v + second_iteration[k]
    end
  end

  def build_from_batch(batch)
    @domain_zones.each_with_object(Hash.new) do |zone, acc|
      acc[zone.to_sym] = batch
    end
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