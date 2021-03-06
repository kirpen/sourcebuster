require 'test_helper'

module Sourcebuster
  class RefererSourceTest < ActiveSupport::TestCase

	  test "referer source domain and referer_type should not be empty" do
		  r_s = Sourcebuster::RefererSource.new
		  assert r_s.invalid?
		  assert r_s.errors[:domain].any?
		  assert r_s.errors[:referer_type_id].any?
	  end

	  test "referer source domain should be unique" do
		  r_s_domain = 'Google.com'
		  r_s_1 = Sourcebuster::RefererSource.new(domain: r_s_domain,
		                                          referer_type_id: 1)
		  r_s_2 = Sourcebuster::RefererSource.new(domain: r_s_domain.downcase,
		                                          referer_type_id: 2)
		  assert r_s_1.save
		  r_s_2.valid?
		  assert r_s_2.errors[:domain].any?
	  end

	  test "referer source domain should not have www and http stuff" do
		  r_s_domain_1 = 'http://www.Google-ht.com'
		  r_s_1 = Sourcebuster::RefererSource.new(domain: r_s_domain_1,
		                                          referer_type_id: 1)
		  r_s_domain_2 = 'https://www.http-Domain.com'
		  r_s_2 = Sourcebuster::RefererSource.new(domain: r_s_domain_2,
		                                          referer_type_id: 1)
		  assert r_s_1.save
		  assert r_s_1[:domain] == 'google-ht.com'
		  assert r_s_2.save
		  assert r_s_2[:domain] == 'http-domain.com'
	  end

	  test "referer source organic query param should not have equal sign" do
		  r_s_domain = 'google77.com'
		  r_s_oqp = 'q='
		  r_s = Sourcebuster::RefererSource.new(domain: r_s_domain,
		                                        referer_type_id: 2,
		                                        organic_query_param: r_s_oqp)
		  assert r_s.save
		  assert r_s[:organic_query_param] == r_s_oqp.gsub('=', '').downcase
		  assert r_s[:organic_query_param] == 'q'
	  end

  end
end
