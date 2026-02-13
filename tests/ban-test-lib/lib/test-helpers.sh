#!/bin/bash
# Test helper functions and assertions for ban script tests

set -eo pipefail

# Test counters
TESTS_RUN=0
TESTS_PASSED=0
TESTS_FAILED=0

# ANSI color codes
readonly GREEN='\033[0;32m'
readonly RED='\033[0;31m'
readonly YELLOW='\033[1;33m'
readonly NC='\033[0m'  # No Color

# ============================================================================
# Test Assertion Functions
# ============================================================================

# Assert that two values are equal
assert_equals() {
	local actual="$1"
	local expected="$2"
	local message="${3:-Assertion failed}"

	((TESTS_RUN++))

	if [[ "$expected" == "$actual" ]]; then
		echo -e "${GREEN}✓${NC} $message"
		((TESTS_PASSED++))
		return 0
	else
		echo -e "${RED}✗${NC} $message"
		echo "  Expected: $expected"
		echo "  Got: $actual"
		((TESTS_FAILED++))
		return 1
	fi
}

# Assert that a value contains a substring
assert_contains() {
	local haystack="$1"
	local needle="$2"
	local message="${3:-Assertion failed}"

	((TESTS_RUN++))

	if [[ "$haystack" == *"$needle"* ]]; then
		echo -e "${GREEN}✓${NC} $message"
		((TESTS_PASSED++))
		return 0
	else
		echo -e "${RED}✗${NC} $message"
		echo "  Expected to contain: $needle"
		echo "  Got: $haystack"
		((TESTS_FAILED++))
		return 1
	fi
}

# Assert that two values do not equal
assert_not_equals() {
	local unexpected="$1"
	local actual="$2"
	local message="${3:-Assertion failed}"

	((TESTS_RUN++))

	if [[ "$unexpected" != "$actual" ]]; then
		echo -e "${GREEN}✓${NC} $message"
		((TESTS_PASSED++))
		return 0
	else
		echo -e "${RED}✗${NC} $message"
		echo "  Did not expect: $unexpected"
		echo "  But got: $actual"
		((TESTS_FAILED++))
		return 1
	fi
}

# Assert that a file exists
assert_file_exists() {
	local file="$1"
	local message="${2:-File exists: $file}"

	((TESTS_RUN++))

	if [[ -f "$file" ]]; then
		echo -e "${GREEN}✓${NC} $message"
		((TESTS_PASSED++))
		return 0
	else
		echo -e "${RED}✗${NC} $message"
		echo "  File not found: $file"
		((TESTS_FAILED++))
		return 1
	fi
}

# Assert that a file does not exist
assert_file_not_exists() {
	local file="$1"
	local message="${2:-File does not exist: $file}"

	((TESTS_RUN++))

	if [[ ! -f "$file" ]]; then
		echo -e "${GREEN}✓${NC} $message"
		((TESTS_PASSED++))
		return 0
	else
		echo -e "${RED}✗${NC} $message"
		echo "  File should not exist but does: $file"
		((TESTS_FAILED++))
		return 1
	fi
}

# Assert that a string is not empty
assert_not_empty() {
	local value="$1"
	local message="${2:-Value is not empty}"

	((TESTS_RUN++))

	if [[ -n "$value" ]]; then
		echo -e "${GREEN}✓${NC} $message"
		((TESTS_PASSED++))
		return 0
	else
		echo -e "${RED}✗${NC} $message"
		echo "  Expected non-empty value"
		((TESTS_FAILED++))
		return 1
	fi
}

# Assert that a string is empty
assert_empty() {
	local value="$1"
	local message="${2:-Value is empty}"

	((TESTS_RUN++))

	if [[ -z "$value" ]]; then
		echo -e "${GREEN}✓${NC} $message"
		((TESTS_PASSED++))
		return 0
	else
		echo -e "${RED}✗${NC} $message"
		echo "  Expected empty value, got: $value"
		((TESTS_FAILED++))
		return 1
	fi
}

# Assert that a command succeeds (exit code 0)
assert_success() {
	local exit_code="$1"
	local message="${2:-Command succeeded}"

	((TESTS_RUN++))

	if [[ $exit_code -eq 0 ]]; then
		echo -e "${GREEN}✓${NC} $message"
		((TESTS_PASSED++))
		return 0
	else
		echo -e "${RED}✗${NC} $message"
		echo "  Command failed with exit code: $exit_code"
		((TESTS_FAILED++))
		return 1
	fi
}

# Assert that a command fails (exit code != 0)
assert_failure() {
	local exit_code="$1"
	local message="${2:-Command failed}"

	((TESTS_RUN++))

	if [[ $exit_code -ne 0 ]]; then
		echo -e "${GREEN}✓${NC} $message"
		((TESTS_PASSED++))
		return 0
	else
		echo -e "${RED}✗${NC} $message"
		echo "  Command succeeded when it should have failed (exit code: $exit_code)"
		((TESTS_FAILED++))
		return 1
	fi
}

# ============================================================================
# Test Lifecycle Functions
# ============================================================================

# Setup test environment
setup_test_env() {
	export BAN_TEST_MODE=1
	export TEST_TMP
	TEST_TMP=$(mktemp -d)
	export BAN_DB_FILE="$TEST_TMP/test.db"
	export BAN_WHITELIST_FILE="$TEST_TMP/whitelist.txt"
	export BAN_LOG_FILE="$TEST_TMP/ban.log"
	export MAX_AGE_DAYS=10

	# Clear and re-initialize global arrays from ban script
	unset ip_last_seen ip_first_seen ip_hit_count whitelisted_ips
	declare -gA ip_last_seen=()
	declare -gA ip_first_seen=()
	declare -gA ip_hit_count=()
	declare -gA whitelisted_ips=()
}

# Cleanup test environment
cleanup_test_env() {
	rm -rf "$TEST_TMP"
	unset BAN_TEST_MODE
	unset TEST_TMP
	unset BAN_DB_FILE
	unset BAN_WHITELIST_FILE
	unset BAN_LOG_FILE
	unset MAX_AGE_DAYS
}

# Run a test function with setup/cleanup
run_test() {
	local test_name="$1"
	local test_func="$2"

	echo
	echo -e "${YELLOW}Running: $test_name${NC}"
	setup_test_env

	if $test_func; then
		local result=$?
	else
		local result=$?
	fi

	cleanup_test_env
	return $result
}

# Print test summary
print_test_summary() {
	echo
	echo "============================================"
	echo "Test Results"
	echo "============================================"
	echo "Total:  $TESTS_RUN"
	echo -e "Passed: ${GREEN}$TESTS_PASSED${NC}"

	if [[ $TESTS_FAILED -gt 0 ]]; then
		echo -e "Failed: ${RED}$TESTS_FAILED${NC}"
		return 1
	else
		echo -e "Failed: ${GREEN}0${NC}"
		return 0
	fi
}

# ============================================================================
# Fixture Helper Functions
# ============================================================================

# Get path to fixture file
get_fixture_file() {
	local fixture_name="$1"
	local script_dir
	script_dir=$(dirname "$(readlink -f "${BASH_SOURCE[0]}")/..")
	echo "$script_dir/fixtures/$fixture_name"
}

# Get fixture directory
get_fixture_dir() {
	local script_dir
	script_dir=$(dirname "$(readlink -f "${BASH_SOURCE[0]}")/..")
	echo "$script_dir/fixtures"
}
