class Gitless < Formula
  include Language::Python::Virtualenv

  desc "Simplified version control system on top of git"
  homepage "https://gitless.com/"
  url "https://github.com/sdg-mit/gitless/archive/v0.8.6.tar.gz"
  sha256 "e1d009bf9d7c89428d7029394cc85a0d91bd2af73f019508ddc92c98faeed8e5"
  revision 3

  bottle do
    cellar :any
    sha256 "0d80d148f18f3ac01af5593573eeb8570d1cadeaecaac4d6a00d51d7ef82c44c" => :mojave
    sha256 "d424d1d7ccb79d9ad9cd4cc3a6d52e4571eb6f23fcb5de9772292d77315e510e" => :high_sierra
    sha256 "8c307b1ee20d519c8bb8658c9ceab72fefbf3095d6296b2347875ae9f4095dcf" => :sierra
  end

  depends_on "libgit2"
  depends_on "python"

  resource "args" do
    url "https://files.pythonhosted.org/packages/e5/1c/b701b3f4bd8d3667df8342f311b3efaeab86078a840fb826bd204118cc6b/args-0.1.0.tar.gz"
    sha256 "a785b8d837625e9b61c39108532d95b85274acd679693b71ebb5156848fcf814"
  end

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/10/f7/3b302ff34045f25065091d40e074479d6893882faef135c96f181a57ed06/cffi-1.11.4.tar.gz"
    sha256 "df9083a992b17a28cd4251a3f5c879e0198bb26c9e808c4647e0a18739f1d11d"
  end

  resource "clint" do
    url "https://files.pythonhosted.org/packages/3d/b4/41ecb1516f1ba728f39ee7062b9dac1352d39823f513bb6f9e8aeb86e26d/clint-0.5.1.tar.gz"
    sha256 "05224c32b1075563d0b16d0015faaf9da43aa214e4a2140e51f08789e7a4c5aa"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/8c/2d/aad7f16146f4197a11f8e91fb81df177adcc2073d36a17b1491fd09df6ed/pycparser-2.18.tar.gz"
    sha256 "99a8ca03e29851d96616ad0404b4aad7d9ee16f25c9f9708a11faf2810f7b226"
  end

  resource "pygit2" do
    url "https://files.pythonhosted.org/packages/ec/56/9f591bee962dcdc3c4268c4bf0a836d5188b1604e58e3618df12a963573b/pygit2-0.28.1.tar.gz"
    sha256 "2ccdb865ef530c799a6430d0e52952925ffc0d7c856e7608f4cf42f4b821412b"
  end

  resource "sh" do
    url "https://files.pythonhosted.org/packages/7c/71/199d27d3e7e78bf448bcecae0105a1d5b29173ffd2bbadaa95a74c156770/sh-1.12.14.tar.gz"
    sha256 "b52bf5833ed01c7b5c5fb73a7f71b3d98d48e9b9b8764236237bdc7ecae850fc"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/16/d8/bc6316cf98419719bd59c91742194c111b6f2e85abac88e496adefaf7afe/six-1.11.0.tar.gz"
    sha256 "70e8a77beed4562e7f14fe23a786b54f6296e34344c23bc42f07b15018ff98e9"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin/"gl", "init"
    system "git", "config", "user.name", "Gitless Install"
    system "git", "config", "user.email", "Gitless@Install"
    %w[haunted house].each { |f| touch testpath/f }
    system bin/"gl", "track", "haunted", "house"
    system bin/"gl", "commit", "-m", "Initial Commit"
    assert_equal "haunted\nhouse", shell_output("git ls-files").strip
  end
end
