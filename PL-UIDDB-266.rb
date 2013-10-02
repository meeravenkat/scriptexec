#========================================================================================
#                 Copyright (C) Hospira, Inc.
#                       All rights reserved
#========================================================================================
# Notice:  All Rights Reserved.
# This material contains the trade secrets and confidential information of Hospira, Inc.,
# which embody substantial creative effort, ideas and expressions. No part of this
# material may be reproduced or transmitted in any form or by any means, electronic,
# mechanical, optical or otherwise, including photocopying and recording, or in
# connection with any information storage or retrieval system, without written permission
# from:
#
# Hospira, Inc.
# 13520 Evening Creek Dr., Suite 200
# San Diego, CA 92128
# www.hospira.com
#========================================================================================
# File: PL-DID-SWFU-2609.rb
#
# DESCRIPTION
#     This test script verifies the requirement matching the name of this file.
#
#========================================================================================
require "testutilities" #-- Contains logging & configuration functionality
require "plumapi"       #-- API for object under test

#------------------------------------
# Source any required scriptlet files
require_relative "../../../Scriptlets/GenericScriptlets.rb"
require_relative "../../../Scriptlets/NavigationScriptlets.rb"

#---------------------------------
# Define the test result constants
PASS    = "PASS"
FAIL    = "FAIL"
UNKNOWN = "UNKNOWN"

#--------------------------------
# Initialize the result variables
actualResult = []
result       = UNKNOWN

#---------------------------------
# Create an instance of TestConfig
tc = TestConfig.new

#-----------------------------------------------------------------
# Extract values from configuration file for the common parameters
LOG_PATH                  = tc.get_value_for("log-path")
POWER_ON                  = tc.get_value_for("power-on")
CONNECTION_TYPE           = tc.get_value_for("connection-type")
POWER_OFF                 = tc.get_value_for("power-off")
NEW_PATIENT               = eval(tc.get_value_for("new-patient"))
CCA_NAME                  = tc.get_value_for("cca-name")
THERAPY_METHOD            = tc.get_value_for("therapy-method")
KEY_LINE                  = tc.get_value_for("key-line")
KEY_CALLBACK              = tc.get_value_for("key-callback")
KEY_CONC_PARAMS           = tc.get_value_for("key-conc-params")
KEY_VOLUME_PARAMS         = tc.get_value_for("key-volume-params")
KEY_FIRST_STEP_VALUES     = tc.get_value_for("key-first-step-values")
KEY_SECOND_STEP_VALUES    = tc.get_value_for("key-second-step-values")
KEY_DOSE_VALUES           = tc.get_value_for("key-dose-values")
KEY_RATE_VALUES           = tc.get_value_for("key-rate-values")
SCREEN_NAME_S22           = tc.get_value_for("screen-name-s22")
SCREEN_NAME_S27           = tc.get_value_for("screen-name-s27")
SCREEN_NAME_S30_ST_DC     = tc.get_value_for("screen-name-s30-st-dc")
SCREEN_NAME_S31_LD_DC     = tc.get_value_for("screen-name-s31-ld-dc")
SCREEN_NAME_S32_MS_DC     = tc.get_value_for("screen-name-s32-ms-dc")
CONC_VALUES               = eval(tc.get_value_for("conc-values"))
ST_VALUES_ML              = eval(tc.get_value_for("st-values-ml"))
ST_VALUES_DC              = eval(tc.get_value_for("st-values-dc"))
LD_VALUES_ML              = eval(tc.get_value_for("ld-values-ml"))
LD_VALUES_DC              = eval(tc.get_value_for("ld-values-dc"))
MS_VALUES_ML              = eval(tc.get_value_for("ms-values-ml"))
MS_VALUES_DC              = eval(tc.get_value_for("ms-values-dc"))
STEP_1                    = eval(tc.get_value_for("step-1"))
STEP_2                    = eval(tc.get_value_for("step-2"))
STEP_3                    = eval(tc.get_value_for("step-3"))
EXPECTED_VALUE            = eval(tc.get_value_for("expected-value"))
EXPECTED_TIME             = tc.get_value_for("expected-time")
PIGGYBACK_MODE            = tc.get_value_for("piggyback-mode")
LINE_A                    = tc.get_value_for("line-a")
LINE_B                    = tc.get_value_for("line-b")
LINE_STATUS_PUMPING       = tc.get_value_for("line-status-pumping")
STOP_HARDKEY              = tc.get_value_for("stop-hardkey")
DRUG_AMOUNT_FIELD         = tc.get_value_for("drug-amount-field")
DRUG_DILUENT_FIELD        = tc.get_value_for("drug-diluent-field")
CALLBACK_INDICATOR_FIELD  = tc.get_value_for("callback-indicator-field")
STANDARD_THERAPY          = tc.get_value_for("standard-therapy")
LOADING_DOSE_THERAPY      = tc.get_value_for("loading-dose-therapy")
MULTISTEP_THERAPY         = tc.get_value_for("multistep-therapy")
EXPECTED_VALUE            = eval(tc.get_value_for("expected-value"))
EXPECTED_TIME             = tc.get_value_for("expected-time")
STANDARD_THERAPY_HASH     = eval(tc.get_value_for("standard-therapy-hash"))
LOADING_DOSE_THERAPY_HASH = eval(tc.get_value_for("loading-dose-therapy-hash"))
MULTISTEP_THERAPY_HASH    = eval(tc.get_value_for("multistep-therapy-hash"))

#-------------------------------------------------------
# Extract values from configuration file for test case 1
TEST_CASE_1       = tc.get_value_for("test-case-1")
EXPECTED_RESULT_1 = eval(tc.get_value_for("expected-result-1"))

#-------------------------------------------------------
# Extract values from configuration file for test case 2
TEST_CASE_2       = tc.get_value_for("test-case-2")
EXPECTED_RESULT_2 = eval(tc.get_value_for("expected-result-2"))

#-------------------------------------------------------
# Extract values from configuration file for test case 3
TEST_CASE_3       = tc.get_value_for("test-case-3")
EXPECTED_RESULT_3 = eval(tc.get_value_for("expected-result-3"))

#-------------------------------------------------------
# Extract values from configuration file for test case 4
TEST_CASE_4       = tc.get_value_for("test-case-4")
EXPECTED_RESULT_4 = eval(tc.get_value_for("expected-result-4"))

#-------------------------------------------------------
# Extract values from configuration file for test case 5
TEST_CASE_5       = tc.get_value_for("test-case-5")
EXPECTED_RESULT_5 = eval(tc.get_value_for("expected-result-5"))

#-------------------------------------------------------
# Extract values from configuration file for test case 6
TEST_CASE_6       = tc.get_value_for("test-case-6")
EXPECTED_RESULT_6 = eval(tc.get_value_for("expected-result-6"))

#---------------------------
# Initialize local variables
returnValue    = []
testCases      = []
therapyMethod  = nil

#-------------------------------------------------------------------
# Create hashes for each test case and append in the test case array
testCases << {:testCase        => TEST_CASE_1,
              :lineParam       => LINE_A,
              :therapyType     => STANDARD_THERAPY,
              :therapyHashName => STANDARD_THERAPY_HASH,
              :screenName      => SCREEN_NAME_S30_ST_DC,
              :expectedResult  => EXPECTED_RESULT_1}
testCases << {:testCase        => TEST_CASE_2,
              :lineParam       => LINE_B,
              :therapyType     => STANDARD_THERAPY,
              :therapyHashName => STANDARD_THERAPY_HASH,
              :screenName      => SCREEN_NAME_S30_ST_DC,
              :expectedResult  => EXPECTED_RESULT_2}
testCases << {:testCase        => TEST_CASE_3,
              :lineParam       => LINE_A,
              :therapyType     => LOADING_DOSE_THERAPY,
              :therapyHashName => LOADING_DOSE_THERAPY_HASH,
              :screenName      => SCREEN_NAME_S31_LD_DC,
              :expectedResult  => EXPECTED_RESULT_3}
testCases << {:testCase        => TEST_CASE_4,
              :lineParam       => LINE_B,
              :therapyType     => LOADING_DOSE_THERAPY,
              :therapyHashName => LOADING_DOSE_THERAPY_HASH,
              :screenName      => SCREEN_NAME_S31_LD_DC,
              :expectedResult  => EXPECTED_RESULT_4}
testCases << {:testCase        => TEST_CASE_5,
              :lineParam       => LINE_A,
              :therapyType     => MULTISTEP_THERAPY,
              :therapyHashName => MULTISTEP_THERAPY_HASH,
              :screenName      => SCREEN_NAME_S32_MS_DC,
              :expectedResult  => EXPECTED_RESULT_5}
testCases << {:testCase        => TEST_CASE_6,
              :lineParam       => LINE_B,
              :therapyType     => MULTISTEP_THERAPY,
              :therapyHashName => MULTISTEP_THERAPY_HASH,
              :screenName      => SCREEN_NAME_S32_MS_DC,
              :expectedResult  => EXPECTED_RESULT_6}

#---------------------------
# Create the output log file
tc.create_logger(LOG_PATH)
tc.report_requirement_data

#-------------------------------------------------------------------
# Create the Plum instance, power on the infuser and navigate to the
# "Main Delivery" screen (S22)
plum = PlumApi.new(tc.logger)
plum.general.set_infuser_power(POWER_ON, CONNECTION_TYPE)
s_navigate_to_main_delivery_screen(plum, NEW_PATIENT, CCA_NAME)
testCases.each do |testCase| #-- Start of loop

   tc.testcase_begin(testCase[:testCase])

   #----------------------------------------------------------------------------------------------------
   # Dose based program
   # Test case 1 verifies that when there is a confirmed program and the current line is not delivering and
   # concentration is not at its default value and there is a change to the concentration
   # then the Callback, Diluent, Dose, Rate, VTBI and Duration are reset to default values for
   # Program Therapy Screen (S30) on Line A
   # Test case 2 verifies that when there is a confirmed program and the current line is not delivering and
   # concentration is not at its default value and there is a change to the concentration
   # then the Callback, Diluent, Dose, Rate, VTBI and Duration are reset to default values for
   # Program Therapy Screen (S30) on Line B
   # Test case 3 verifies that when there is a confirmed program and the current line is not delivering and
   # concentration is not at its default value and there is a change to the concentration
   # then the Callback, Diluent, Dose, Rate, VTBI and Duration are reset to default values for
   # Program Loading Dose Screen (S31) on Line A
   # Test case 4 verifies that when there is a confirmed program and the current line is not delivering and
   # concentration is not at its default value and there is a change to the concentration
   # then the Callback, Diluent, Dose, Rate, VTBI and Duration are reset to default values for
   # Program Loading Dose Screen (S31) on Line B
   # Test case 5 verifies that when there is a confirmed program and the current line is not delivering and
   # concentration is not at its default value and there is a change to the concentration
   # then the Callback, Diluent, Dose, Rate, VTBI and Duration are reset to default values for
   # Program Multistep Screen (S32) on Line A
   # Test case 6 verifies that when there is a confirmed program and the current line is not delivering and
   # concentration is not at its default value and there is a change to the concentration
   # then the Callback, Diluent, Dose, Rate, VTBI and Duration are reset to default values for
   # Program Multistep Screen (S32) on Line B

   #---------------------------------------------------------------------
   # Assign values to variables based on the testcase currently executing
   therapyMethod = THERAPY_METHOD+testCase[:therapyType].downcase
   testCase[:therapyHashName][KEY_LINE] = testCase[:lineParam]

   testCase[:therapyHashName][KEY_DOSING_UNIT] = DOSING_UNIT
   testCase[:therapyHashName][KEY_CONC_PARAMS] = CONC_VALUES
   if (testCase[:therapyType] == STANDARD_THERAPY)
      if (testCase[:lineParam] == LINE_B)
         testCase[:therapyHashName][KEY_CALLBACK] = true
      end
      testCase[:therapyHashName][KEY_VOLUME_PARAMS] = ST_VALUES_DC
   elsif (testCase[:therapyType] == LOADING_DOSE_THERAPY)
      testCase[:therapyHashName][KEY_FIRST_STEP_VALUES]  = LD_VALUES_DC
      testCase[:therapyHashName][KEY_SECOND_STEP_VALUES] = LD_VALUES_DC
   elsif (testCase[:therapyType] == MULTISTEP_THERAPY)
      testCase[:therapyHashName][KEY_RATE_VALUES] = nil
      testCase[:therapyHashName][KEY_DOSE_VALUES] = MS_VALUES_DC
   end

   #-----------------------
   # Assign loop statements
   if (testCase[:therapyType].eql? STANDARD_THERAPY)
      stepCount = [nil]
   elsif (testCase[:therapyType].eql? LOADING_DOSE)
      stepCount = (STEP_1..STEP_2)
   elsif testCase[:therapyType].eql? MULTI_STEP_PG1
      stepCount = (STEP_1..STEP_3)
   elsif testCase[:therapyType].eql? MULTI_STEP_PG2
      stepCount = (STEP_4..STEP_10)
   end

   #---------------------------------------------------------------
   # Verify that the current screen is "Main Delivery Screen" (S22)
   unless (plum.general.check_screen_id(SCREEN_NAME_S22).eql? false)

   if testCase[:lineParam] = LINE_B
      STANDARD_THERAPY_HASH[KEY_CALLBACK] = true
      STANDARD_THERAPY_HASH[KEY_DELIVERY_MODE] = PIGGYBACK_MODE
   end
      #-----------------
      # Starting Therapy
      if (testCase[:therapyType].eql? STANDARD_THERAPY)
         STANDARD_THERAPY_HASH[KEY_LINE] = testCase[:lineParam]
         returnValue << s_start_standard_therapy(plum, STANDARD_THERAPY_HASH)
      elsif (testCase[:therapyType].eql? LOADING_DOSE)
         LOADING_DOSE_THERAPY_HASH[KEY_LINE] = testCase[:lineParam]
         returnValue << s_start_loading_dose_therapy(plum, LOADING_DOSE_THERAPY_HASH)
      elsif (testCase[:therapyType].eql? MULTI_STEP_PG1)
         MULTISTEP_THERAPY_HASH[KEY_LINE] = testCase[:lineParam]
         returnValue << s_start_multistep_therapy(plum, MULTISTEP_THERAPY_HASH)
      end
      returnValue << plum.therapy.check_line_status(testCase[:lineParam], LINE_STATUS_PUMPING)
      plum.general.press_hard_key(STOP_HARDKEY)
      eval("plum.general.press_#{testCase[:lineParam].downcase}(SCREEN_NAME_S22)")
      returnValue << plum.general.press_no(SCREEN_NAME_S27)
      returnValue << plum.general.check_screen_id(testCase[:screenName])

      #--------------------------------------------------------------------
      # Verifying that the program parameters are not at its default values
      returnValue << plum.therapy.check_concentration_amount(testCase[:screenName], DRUG_AMOUNT_FIELD, INVALID_CHARACTERS)
      returnValue << plum.therapy.check_concentration_diluent(testCase[:screenName], DRUG_DILUENT_FIELD, INVALID_CHARACTERS)
      returnValue << plum.general.is_field_present(testCase[:screenName], CALLBACK_INDICATOR_FIELD, true)
      stepCount.each do |stepNum|
         returnValue << plum.therapy.check_dose_value(testCase[:screenName], INVALID_CHARACTERS, stepNum)
         returnValue << (plum.therapy.check_rate_value(testCase[:screenName], EXPECTED_VALUE, stepNum).eql? false)
         returnValue << plum.therapy.check_vtbi_value(testCase[:screenName], INVALID_CHARACTERS, stepNum)
         returnValue << (plum.therapy.check_duration_value(testCase[:screenName], EXPECTED_TIME, stepNum).eql? false)
      end

      #-------------------------------
      # Change the Concentration value
      plum.therapy.set_concentration_values(testCase[:screenName], DRUG_AMOUNT_NEW, nil)

      #---------------------------------------------------------------------------------
      # Verify that the program parameters have been changed to their default parameters
      returnValue << plum.therapy.check_concentration_diluent(testCase[:screenName], DRUG_DILUENT_FIELD, EXPECTED_VALUE)
      returnValue << plum.general.is_field_present(testCase[:screenName], CALLBACK_INDICATOR_FIELD, false)
      stepCount.each do |stepNum|
         returnValue << plum.therapy.check_dose_value(testCase[:screenName], EXPECTED_VALUE, stepNum)
         returnValue << plum.therapy.check_rate_value(testCase[:screenName], EXPECTED_VALUE, stepNum)
         returnValue << plum.therapy.check_vtbi_value(testCase[:screenName], EXPECTED_VALUE, stepNum)
         returnValue << plum.therapy.check_duration_value(testCase[:screenName], EXPECTED_TIME, stepNum)
      end

      #---------------------------------
      # Return to "Main Delivery" screen
      plum.general.press_return_ab(testCase[:screenName])

      #--------------------------------------------------------------------------
      # Nil check and assign boolean value to actual result based on return value
      actualResult << ((returnValue.include? false or returnValue.include? nil or returnValue.empty?)? false : true)

      #------------------
      # Result comparison
      result = (actualResult.eql? testCase[:expectedResult])? PASS : FAIL
   else
      result = FAIL
   end

   #---------------------------------------------
   # Record the test result and end the test case
   output = plum.general.get_output_data
   tc.report_result(testCase[:testCase], output["ActualData"], output["ExpectedData"], result, output["MethodName"])
   tc.testcase_end(testCase[:testCase])

   unless (testCases.last.eql? testCase)
      #---------------------------------------------------
      # Reset the result variables and test case variables
      result         = UNKNOWN
      actualResult.clear
      returnValue.clear
      therapyMethod = nil
   end
end  #-- End of loop

#---------------------
# Shutdown the Infuser
plum.general.set_infuser_power(POWER_OFF, CONNECTION_TYPE)

#-------------------------------------------------------
# Generate the test evidence and close the Plum instance
screenHash = plum.general.get_screen_hash
tc.generate_evidence_file(LOG_PATH, File.basename(__FILE__, ".rb"), screenHash)
plum.close()
