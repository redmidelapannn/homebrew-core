class IsSh < Formula
  desc "Human readable conditions for bash"
  homepage "https://github.com/qzb/is.sh"
  url "https://github.com/qzb/is.sh/archive/v1.0.1.tar.gz"
  sha256 "30e5cdce967e6051be7f4afd1422fa12157d7d73af0572c4127ff52f788adb04"

  bottle do
    cellar :any_skip_relocation
    sha256 "a451ce6192b23328c606bedbeff3f62c358825a7df1c78b41d09794075c3a206" => :el_capitan
    sha256 "fe37e879a059923a652995b9dfe5189d0c3cca967c7243971a5d75a5679049b5" => :yosemite
    sha256 "faf15d7f961b8d4514d26c28cf56ff15eab6fb3539184eed39e66e6ce8316f00" => :mavericks
  end

  def install
    bin.install "is.sh"
    bin.install_symlink bin/"is.sh" => "is"
    share.install "tests"
  end

  test do
    ["is", "is.sh"].each do |cmd|
      shell_output("#{share}/tests/tests.sh #{cmd}")
    end
  end
end
