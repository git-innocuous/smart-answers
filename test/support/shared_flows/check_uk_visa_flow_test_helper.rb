module CheckUkVisaFlowTestHelper
  def test_estonia_latvia_alien_outcome_guidance
    %w[estonia latvia].each do |country|
      should "render visa country guidance when an alien #{country} passport is held" do
        add_responses what_passport_do_you_have?: country,
                      what_sort_of_passport?: "alien"
        assert_rendered_outcome text: "You must apply for your visa from the country you’re currently living in."
      end
    end
  end

  def test_stateless_or_refugee_outcome_guidance
    should "render visa country guidance when passport country is stateless-or-refugee" do
      add_responses what_passport_do_you_have?: "stateless-or-refugee"
      assert_rendered_outcome text: "You must apply for your visa from the country you’re originally from or currently living in."
    end
  end

  def test_bno_outcome_guidance
    should "render visa country guidance when passport country is in the BNO list" do
      add_responses what_passport_do_you_have?: "british-national-overseas"
      assert_rendered_outcome text: "If you have British national (overseas) status"
    end
  end

  def test_country_in_youth_mobility_outcome_guidance
    should "render visa country guidance when passport country is in the Youth Mobility scheme" do
      add_responses what_passport_do_you_have?: "canada"
      assert_rendered_outcome text: "If you’re aged 18 to 30"
    end
  end

  def test_shared_purpose_of_visit_next_nodes
    should "have a next node of staying_for_how_long? for a 'study' response" do
      assert_next_node :staying_for_how_long?, for_response: "study"
    end

    should "have a next node of staying_for_how_long? for a 'work' response" do
      assert_next_node :staying_for_how_long?, for_response: "work"
    end

    should "have a next node of staying_for_how_long? for a 'diplomatic' response" do
      assert_next_node :outcome_diplomatic_business, for_response: "diplomatic"
    end

    context "for a 'school' response" do
      should "have a next node of outcome_school_waiver for a electronic visa waiver country passport" do
        add_responses what_passport_do_you_have?: @electronic_visa_waiver_country
        assert_next_node :outcome_school_waiver, for_response: "school"
      end

      should "have a next node of outcome_study_waiver_taiwan for a Taiwan passport" do
        add_responses what_passport_do_you_have?: "taiwan"
        assert_next_node :outcome_study_waiver_taiwan, for_response: "school"
      end

      should "have a next node of outcome_school_n for a non-visa national passport" do
        add_responses what_passport_do_you_have?: @non_visa_national_country
        assert_next_node :outcome_school_n, for_response: "school"
      end

      should "have a next node of outcome_school_n for a British overseas territory passport" do
        add_responses what_passport_do_you_have?: @british_overseas_territory_country
        assert_next_node :outcome_school_n, for_response: "school"
      end

      should "have a next node of outcome_school_n for an EEA passport" do
        add_responses what_passport_do_you_have?: @eea_country
        assert_next_node :outcome_school_n, for_response: "school"
      end

      should "have a next node of outcome_school_y for other passports" do
        add_responses what_passport_do_you_have?: @visa_national_country
        assert_next_node :outcome_school_y, for_response: "school"
      end
    end

    context "for a 'medical' response" do
      should "have a next node of outcome_visit_waiver for a electronic visa waiver country passport" do
        add_responses what_passport_do_you_have?: @electronic_visa_waiver_country
        assert_next_node :outcome_visit_waiver, for_response: "medical"
      end

      should "have a next node of outcome_visit_waiver_taiwan for a Taiwan passport" do
        add_responses what_passport_do_you_have?: "taiwan"
        assert_next_node :outcome_visit_waiver_taiwan, for_response: "medical"
      end

      should "have a next node of outcome_medical_n for a non-visa national passport" do
        add_responses what_passport_do_you_have?: @non_visa_national_country
        assert_next_node :outcome_medical_n, for_response: "medical"
      end

      should "have a next node of outcome_medical_n for a British overseas territory passport" do
        add_responses what_passport_do_you_have?: @british_overseas_territory_country
        assert_next_node :outcome_medical_n, for_response: "medical"
      end

      should "have a next node of outcome_medical_n for an EEA passport" do
        add_responses what_passport_do_you_have?: @eea_country
        assert_next_node :outcome_medical_n, for_response: "medical"
      end

      should "have a next node of outcome_medical_n for a travel document country with a passport" do
        add_responses what_passport_do_you_have?: @travel_document_country,
                      what_sort_of_travel_document?: "passport"
        assert_next_node :outcome_medical_n, for_response: "medical"
      end

      should "have a next node of outcome_medical_y for a travel document country with a travel document" do
        add_responses what_passport_do_you_have?: @travel_document_country,
                      what_sort_of_travel_document?: "travel_document"
        assert_next_node :outcome_medical_y, for_response: "medical"
      end

      should "have a next node of outcome_medical_y for other passports" do
        add_responses what_passport_do_you_have?: @visa_national_country
        assert_next_node :outcome_medical_y, for_response: "medical"
      end
    end

    context "for a 'tourism' response" do
      should "have a next node of outcome_visit_waiver for a electronic visa waiver country passport" do
        add_responses what_passport_do_you_have?: @electronic_visa_waiver_country
        assert_next_node :outcome_visit_waiver, for_response: "tourism"
      end

      should "have a next node of outcome_visit_waiver_taiwan for a Taiwan passport" do
        add_responses what_passport_do_you_have?: "taiwan"
        assert_next_node :outcome_visit_waiver_taiwan, for_response: "tourism"
      end

      should "have a next node of outcome_tourism_n for a non-visa national passport" do
        add_responses what_passport_do_you_have?: @non_visa_national_country
        assert_next_node :outcome_tourism_n, for_response: "tourism"
      end

      should "have a next node of outcome_tourism_n for an EEA passport" do
        add_responses what_passport_do_you_have?: @eea_country
        assert_next_node :outcome_tourism_n, for_response: "tourism"
      end

      should "have a next node of outcome_tourism_n for a British overseas territory passport" do
        add_responses what_passport_do_you_have?: @british_overseas_territory_country
        assert_next_node :outcome_tourism_n, for_response: "tourism"
      end

      should "have a next node of outcome_tourism_n for a travel document country with a passport" do
        add_responses what_passport_do_you_have?: @travel_document_country,
                      what_sort_of_travel_document?: "passport"
        assert_next_node :outcome_tourism_n, for_response: "tourism"
      end

      should "have a next node of outcome_tourism_y for a travel document country with a travel document" do
        add_responses what_passport_do_you_have?: @travel_document_country,
                      what_sort_of_travel_document?: "travel_document"
        assert_next_node :travelling_visiting_partner_family_member?, for_response: "tourism"
      end

      should "have a next node of outcome_tourism_y for other passports" do
        add_responses what_passport_do_you_have?: @visa_national_country
        assert_next_node :travelling_visiting_partner_family_member?, for_response: "tourism"
      end
    end

    context "for a 'marriage' response" do
      should "have a next node of outcome_marriage_nvn_british_overseas_territories for an EEA passport" do
        add_responses what_passport_do_you_have?: @eea_country
        assert_next_node :outcome_marriage_nvn_british_overseas_territories, for_response: "marriage"
      end

      should "have a next node of :outcome_marriage_nvn_british_overseas_territories for a non-visa national passport" do
        add_responses what_passport_do_you_have?: @non_visa_national_country
        assert_next_node :outcome_marriage_nvn_british_overseas_territories, for_response: "marriage"
      end

      should "have a next node of :outcome_marriage_nvn_british_overseas_territories for a British overseas " \
             "territory passport" do
        add_responses what_passport_do_you_have?: @british_overseas_territory_country
        assert_next_node :outcome_marriage_nvn_british_overseas_territories, for_response: "marriage"
      end

      should "have a next node of outcome_marriage_electronic_visa_waiver for a electronic visa waiver country passport" do
        add_responses what_passport_do_you_have?: @electronic_visa_waiver_country
        assert_next_node :outcome_marriage_electronic_visa_waiver, for_response: "marriage"
      end

      should "have a next node of outcome_marriage_taiwan for a Taiwan passport" do
        add_responses what_passport_do_you_have?: "taiwan"
        assert_next_node :outcome_marriage_taiwan, for_response: "marriage"
      end

      should "have a next node of outcome_marriage_visa_nat_direct_airside_transit_visa for a direct airside " \
             "transit visa country" do
        add_responses what_passport_do_you_have?: @direct_airside_transit_visa_country
        assert_next_node :outcome_marriage_visa_nat_direct_airside_transit_visa, for_response: "marriage"
      end

      should "have a next node of outcome_marriage_visa_nat_direct_airside_transit_visa for a visa national country" do
        add_responses what_passport_do_you_have?: @visa_national_country
        assert_next_node :outcome_marriage_visa_nat_direct_airside_transit_visa, for_response: "marriage"
      end
    end

    context "for a 'family' response" do
      should "have a next node of outcome_joining_family_m for a British overseas territory passport" do
        add_responses what_passport_do_you_have?: @british_overseas_territory_country
        assert_next_node :outcome_joining_family_m, for_response: "family"
      end

      should "have a next node of outcome_joining_family_nvn for a non-visa national passport" do
        add_responses what_passport_do_you_have?: @non_visa_national_country
        assert_next_node :outcome_joining_family_nvn, for_response: "family"
      end

      should "have a next node of outcome_joining_family_nvn for an EEA passport" do
        add_responses what_passport_do_you_have?: @eea_country
        assert_next_node :outcome_joining_family_nvn, for_response: "family"
      end

      should "have a next node of partner_family_british_citizen? for other passports" do
        add_responses what_passport_do_you_have?: @visa_national_country
        assert_next_node :partner_family_british_citizen?, for_response: "family"
      end
    end
  end
end
