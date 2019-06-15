class TerraformLandscape < Formula
  desc "Improve Terraform's plan output"
  homepage "https://github.com/coinbase/terraform-landscape"
  url "https://github.com/coinbase/terraform-landscape/archive/v0.3.2.tar.gz"
  sha256 "2fef358c16fe58f87e74a7d777ce669b5c2b368b4fcdba98d114948484156532"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "d24fb7d002efd2546b2869a0f1434412ae4c480fea8c8472ab4d477cedce5e0b" => :mojave
    sha256 "bb51f858ce4b2aa66b79940a09046190751209869a367252936c396fcdbfe99d" => :high_sierra
    sha256 "991d0ec0e8f2039639a008bf0338a96ad1a293d421fb8eb6d33e469bdaee4744" => :sierra
  end

  depends_on "ruby"

  resource "colorize" do
    url "https://rubygems.org/gems/colorize-0.8.1.gem"
    sha256 "0ba0c2a58232f9b706dc30621ea6aa6468eeea120eb6f1ccc400105b90c4798c"
  end

  resource "commander" do
    url "https://rubygems.org/gems/commander-4.4.7.gem"
    sha256 "8fc35d22ba7a386adecb728e68908e98b6a076340aaec6c654583a93ca9faadf"
  end

  resource "diffy" do
    url "https://rubygems.org/gems/diffy-3.3.0.gem"
    sha256 "909af322005817dfd848afb85ba5a30c65c38299b288349ac8c1744607391d62"
  end

  resource "highline" do
    url "https://rubygems.org/gems/highline-2.0.1.gem"
    sha256 "ec0bab47f397b32d09b599629cf32f4fc922470a09bef602ef5e492127bb263f"
  end

  resource "polyglot" do
    url "https://rubygems.org/gems/polyglot-0.3.5.gem"
    sha256 "59d66ef5e3c166431c39cb8b7c1d02af419051352f27912f6a43981b3def16af"
  end

  resource "treetop" do
    url "https://rubygems.org/gems/treetop-1.6.10.gem"
    sha256 "67df9f52c5fdeb7b2b8ce42156f9d019c1c4eb643481a68149ff6c0b65bc613c"
  end

  def install
    ENV["GEM_HOME"] = libexec
    resources.each do |r|
      r.fetch
      system "gem", "install", r.cached_download, "--no-document",
                    "--ignore-dependencies", "--install-dir", libexec
    end
    system "gem", "build", "terraform_landscape.gemspec"
    system "gem", "install", "--ignore-dependencies", "terraform_landscape-#{version}.gem"
    bin.install libexec/"bin/landscape"
    bin.env_script_all_files(libexec/"bin", :GEM_HOME => ENV["GEM_HOME"])
  end

  test do
    output = shell_output("#{bin}/landscape -v")
    assert_match "Terraform Landscape #{version}", output

    test_input = "+ some_resource_type.some_resource_name"
    colorized_expected_output = "\e[0;32;49m+ some_resource_type.some_resource_name\e[0m\n\n\n"

    output = shell_output("echo '#{test_input}' | #{bin}/landscape")
    assert_match colorized_expected_output, output
  end
end
