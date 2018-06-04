class GitlabGem < Formula
  desc "Ruby client and CLI for GitLab API"
  homepage "https://github.com/NARKOZ/gitlab"
  url "https://github.com/NARKOZ/gitlab/archive/v4.4.0.tar.gz"
  sha256 "4f560b818007989acfe25adbcf66c2d6ac21cf89c7c9f8d1666493cf38fd03cd"

  bottle do
    cellar :any_skip_relocation
    sha256 "370ba4b9e70f7d780b50400aeff2ba11f7e0015b48a8989a86e8022aa6c1eeb3" => :high_sierra
    sha256 "b196b8447773b7adbf9361e3e07fee0603330ac4ff01862d943f58b564156e2c" => :sierra
    sha256 "099a1c60003659f690abea40da21dd8d72304fdf313eb900b5c0ac7f69629f84" => :el_capitan
  end

  depends_on "ruby" if MacOS.version <= :mountain_lion

  resource "httparty" do
    url "https://rubygems.org/gems/httparty-0.16.2.gem"
    sha256 "fc67e5ba443b5ca822c2babccd3c6ed8bcc75fb67432b99652cb95972d204cff"
  end

  resource "terminal-table" do
    url "https://rubygems.org/gems/terminal-table-1.8.0.gem"
    sha256 "13371f069af18e9baa4e44d404a4ada9301899ce0530c237ac1a96c19f652294"
  end

  resource "multi_xml" do
    url "https://rubygems.org/gems/multi_xml-0.6.0.gem"
    sha256 "d24393cf958adb226db884b976b007914a89c53ad88718e25679d7008823ad52"
  end

  resource "unicode-display_width" do
    url "https://rubygems.org/gems/unicode-display_width-1.3.3.gem"
    sha256 "38c078f93b1d2998574672913571e265c9346ba747d6e14217980cc39fb6e157"
  end

  def install
    ENV["GEM_HOME"] = libexec
    resources.each do |r|
      r.verify_download_integrity(r.fetch)
      system "gem", "install", r.cached_download, "--ignore-dependencies",
             "--no-document", "--install-dir", libexec
    end
    system "gem", "build", "gitlab.gemspec"
    system "gem", "install", "--ignore-dependencies", "gitlab-#{version}.gem"
    bin.install "exe/gitlab"
    bin.env_script_all_files(libexec/"exe", :GEM_HOME => ENV["GEM_HOME"])
    libexec.install Dir["*"]
  end

  test do
    ENV["GITLAB_API_ENDPOINT"] = "http://example.com"
    ENV["GITLAB_API_PRIVATE_TOKEN"] = "token"
    output = shell_output("#{bin}/gitlab user 2>&1", 1)
    assert_match "The response is not a valid JSON", output
  end
end
