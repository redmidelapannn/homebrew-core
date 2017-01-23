class CapCompletion < Formula
  desc "Bash completion for Capistrano"
  homepage "https://github.com/bashaus/capistrano-autocomplete"
  url "https://github.com/bashaus/capistrano-autocomplete/archive/v1.0.0.tar.gz"
  sha256 "66a94420be44d82ff18f366778e05decde3f16ad05d35fd8ec7b51860b102c0c"

  bottle do
    cellar :any_skip_relocation
    sha256 "e6a2a367c75d14f06890980ec7751e90c5a972f1381a3bf370099442f377aad1" => :sierra
    sha256 "00b0a1216c269f80bc3d66b7cdecf1f215df9d0fc1c24b3e135c23dba6deaeb4" => :el_capitan
    sha256 "e6a2a367c75d14f06890980ec7751e90c5a972f1381a3bf370099442f377aad1" => :yosemite
  end

  def install
    bash_completion.install "cap"
  end

  test do
    assert_match "-F _cap",
      shell_output("source #{bash_completion}/cap && complete -p cap")
  end
end
