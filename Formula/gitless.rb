class Gitless < Formula
  include Language::Python::Virtualenv

  desc "Simplified version control system on top of git"
  homepage "https://gitless.com/"
  url "https://github.com/gitless-vcs/gitless/archive/v0.8.8.tar.gz"
  sha256 "470aab13d51baec2ab54d7ceb6d12b9a2937f72d840516affa0cb34a6360523c"
  revision 3

  bottle do
    cellar :any
    sha256 "f3d5d4b6d25acfdd8e95fd9d792c278dc2be62c7dd818358f1eb133f12494a5e" => :catalina
    sha256 "ae9e16eb35f7194d376ca52e55ff4345ddad3be46641d151f7014456e1ff065a" => :mojave
    sha256 "906e0b363001c26e8fb5c27016c76c61a406a46680baeb37b63ed2c821da36e7" => :high_sierra
  end

  depends_on "libgit2"
  depends_on "python@3.8"

  uses_from_macos "libffi"

  resource "args" do
    url "https://files.pythonhosted.org/packages/e5/1c/b701b3f4bd8d3667df8342f311b3efaeab86078a840fb826bd204118cc6b/args-0.1.0.tar.gz"
    sha256 "a785b8d837625e9b61c39108532d95b85274acd679693b71ebb5156848fcf814"
  end

  resource "cached-property" do
    url "https://files.pythonhosted.org/packages/57/8e/0698e10350a57d46b3bcfe8eff1d4181642fd1724073336079cb13c5cf7f/cached-property-1.5.1.tar.gz"
    sha256 "9217a59f14a5682da7c4b8829deadbfc194ac22e9908ccf7c8820234e80a1504"
  end

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/93/1a/ab8c62b5838722f29f3daffcc8d4bd61844aa9b5f437341cc890ceee483b/cffi-1.12.3.tar.gz"
    sha256 "041c81822e9f84b1d9c401182e174996f0bae9991f33725d059b771744290774"
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
    url "https://files.pythonhosted.org/packages/1d/c4/e0ba65178512a724a86b39565d7f9286c16d7f8e45e2f665973065c4a495/pygit2-1.1.1.tar.gz"
    sha256 "9255d507d5d87bf22dfd57997a78908010331fc21f9a83eca121a53f657beb3c"
  end

  resource "sh" do
    url "https://files.pythonhosted.org/packages/7c/71/199d27d3e7e78bf448bcecae0105a1d5b29173ffd2bbadaa95a74c156770/sh-1.12.14.tar.gz"
    sha256 "b52bf5833ed01c7b5c5fb73a7f71b3d98d48e9b9b8764236237bdc7ecae850fc"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/16/d8/bc6316cf98419719bd59c91742194c111b6f2e85abac88e496adefaf7afe/six-1.11.0.tar.gz"
    sha256 "70e8a77beed4562e7f14fe23a786b54f6296e34344c23bc42f07b15018ff98e9"
  end

  # Allow to be dependent on pygit2 1.1.1
  # Remove for next version
  patch do
    url "https://github.com/gitless-vcs/gitless/pull/230.patch?full_index=1"
    sha256 "fd4ef60552add5f95944083a8ba867a3b34a197bdbad6b13afcf5ab29ebe09be"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system "git", "config", "--global", "user.email", '"test@example.com"'
    system "git", "config", "--global", "user.name", '"Test"'
    system bin/"gl", "init"
    %w[haunted house].each { |f| touch testpath/f }
    system bin/"gl", "track", "haunted", "house"
    system bin/"gl", "commit", "-m", "Initial Commit"
    assert_equal "haunted\nhouse", shell_output("git ls-files").strip
  end
end
