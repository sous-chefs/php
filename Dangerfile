def code_changes?
  code = %w(libraries attributes recipes resources files templates)
  code.each do |location|
    return true unless git.modified_files.grep(/#{location}/).empty?
  end
  false
end

def test_changes?
  tests = %w(spec test .kitchen.yml .kitchen.dokken.yml)
  tests.each do |location|
    return true unless git.modified_files.grep(/#{location}/).empty?
  end
  false
end

fail 'Please provide a summary of your Pull Request.' if github.pr_body.length < 10

warn 'This is a big Pull Request.' if git.lines_of_code > 400

# Require a CHANGELOG entry for non-test changes.
if !git.modified_files.include?('CHANGELOG.md') && code_changes?
  fail 'Please include a CHANGELOG entry.'
end

# A sanity check for tests.
if git.lines_of_code > 5 && code_changes? && !test_changes?
  warn 'This Pull Request is probably missing tests.'
end
