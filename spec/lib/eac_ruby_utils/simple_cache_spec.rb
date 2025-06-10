# frozen_string_literal: true

class CacheableObject
  include ::EacRubyUtils::SimpleCache

  def my_method_uncached
    @counter ||= 0
    @counter += 1
  end

  def method_with_question_uncached? # rubocop:disable Naming/PredicateMethod
    'question'
  end

  def method_with_exclamation_uncached!
    'exclamation'
  end

  def method_with_args_uncached(arg1)
    @counter2 ||= 0
    @counter2 += 1
    "#{arg1}/#{@counter2}"
  end

  def method_with_reset_uncached
    reset_cache
    'result'
  end

  private

  def private_method_uncached
    @counter3 ||= 0
    @counter3 += 1
  end
end

RSpec.describe EacRubyUtils::SimpleCache do
  let(:instance) { CacheableObject.new }

  describe 'cached value' do
    it 'uncached method return value should update at each call' do
      expect(instance.my_method_uncached).not_to eq(instance.my_method_uncached)
    end

    it 'cached method should return same values at each call' do
      expect(instance.my_method).to eq(instance.my_method) # rubocop:disable RSpec/IdenticalEqualityAssertion
    end

    it 'is able to call private uncached as cached' do
      expect(instance.private_method).to eq(instance.private_method) # rubocop:disable RSpec/IdenticalEqualityAssertion
    end

    it 'return value even if reset cache' do
      expect(instance.method_with_reset).to eq('result')
    end
  end

  describe 'cache value with args' do
    it do
      expect(instance.method_with_args_uncached('123'))
        .not_to eq(instance.method_with_args_uncached('123'))
    end

    it do
      expect(instance.method_with_args_uncached('456'))
        .not_to eq(instance.method_with_args_uncached('456'))
    end

    it do
      expect(instance.method_with_args('123')).to eq(instance.method_with_args('123')) # rubocop:disable RSpec/IdenticalEqualityAssertion
    end

    it do
      expect(instance.method_with_args('456')).to eq(instance.method_with_args('456')) # rubocop:disable RSpec/IdenticalEqualityAssertion
    end

    it do
      expect(instance.method_with_args('456')).not_to eq(instance.method_with_args('123'))
    end
  end

  describe 'method with marks' do
    it 'found uncached method with exclamation mark' do
      expect(instance.method_with_exclamation!).to eq('exclamation')
    end

    it 'found uncached method with question mark' do
      expect(instance.method_with_question?).to eq('question')
    end
  end

  describe '#respond_to?' do
    it 'responds to cached method without args' do
      expect(instance.respond_to?(:my_method)).to be(true)
    end

    it 'responds to cached method with args' do
      expect(instance.respond_to?(:method_with_args)).to be(true)
    end

    it 'responds to cached method of uncached private method' do
      expect(instance.respond_to?(:private_method)).to be(true)
    end

    it 'not respond to not existent method' do
      expect(instance.respond_to?(:not_exist)).to be(false)
    end
  end

  describe '#reset_cache' do
    let(:instance) { CacheableObject.new }
    let(:cached_value) { instance.my_method }

    it 'cached method return should return cached value' do
      expect(instance.my_method).to eq(cached_value)
    end

    context 'when reset_cache method is called' do
      it 'cached method return should return new cached value' do
        cached_value
        instance.reset_cache
        expect(instance.my_method).not_to eq(cached_value)
      end
    end
  end
end
