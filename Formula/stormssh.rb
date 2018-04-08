class Stormssh < Formula
  desc "Command-line tool to manage your ssh connections"
  homepage "https://github.com/emre/storm"
  url "https://files.pythonhosted.org/packages/07/b9/1ed919b9924003ea9abff0ff61116de5e5bac0675b9106fa6efbed10d030/stormssh-0.6.9.tar.gz"
  sha256 "e896597b902d1191bae1f6a9b248d3374258f8775e9726cff1ba2300ad664c8a"
  head "https://github.com/emre/storm.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "1072ec7b5a0a4b64b6d56e207c3931beca9d16f574b7e00acb2c4e63f40cd0f6" => :high_sierra
    sha256 "e4130cb5600717a7640a37da15045063d6ca37bcb8cbca511c2fe033afc3f7b0" => :sierra
    sha256 "39d554a81740307efddbf4dd36c99cf3c00061560a082a581739883f83c6d187" => :el_capitan
  end

  depends_on "python@2"

  conflicts_with "storm", :because => "both install 'storm' binary"

  resource "pycrypto" do
    url "https://files.pythonhosted.org/packages/source/p/pycrypto/pycrypto-2.6.1.tar.gz"
    sha256 "f2ce1e989b272cfcb677616763e0a2e7ec659effa67a88aa92b3a65528f60a3c"
  end

  resource "flask" do
    url "https://files.pythonhosted.org/packages/source/F/Flask/Flask-0.10.1.tar.gz"
    sha256 "4c83829ff83d408b5e1d4995472265411d2c414112298f2eb4b359d9e4563373"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/source/s/six/six-1.10.0.tar.gz"
    sha256 "105f8d68616f8248e24bf0e9372ef04d3cc10104f1980f54d57b2ce73a5ad56a"
  end

  resource "termcolor" do
    url "https://files.pythonhosted.org/packages/source/t/termcolor/termcolor-1.1.0.tar.gz"
    sha256 "1d6d69ce66211143803fbc56652b41d73b4a400a2891d7bf7a1cdf4c02de613b"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/source/M/MarkupSafe/MarkupSafe-0.23.tar.gz"
    sha256 "a4ec1aff59b95a14b45eb2e23761a0179e98319da5a7eb76b56ea8cdc7b871c3"
  end

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/source/J/Jinja2/Jinja2-2.8.tar.gz"
    sha256 "bc1ff2ff88dbfacefde4ddde471d1417d3b304e8df103a7a9437d47269201bf4"
  end

  resource "werkzeug" do
    url "https://files.pythonhosted.org/packages/source/W/Werkzeug/Werkzeug-0.10.4.tar.gz"
    sha256 "9d2771e4c89be127bc4bac056ab7ceaf0e0064c723d6b6e195739c3af4fd5c1d"
  end

  resource "itsdangerous" do
    url "https://files.pythonhosted.org/packages/source/i/itsdangerous/itsdangerous-0.24.tar.gz"
    sha256 "cbb3fcf8d3e33df861709ecaf89d9e6629cff0a217bc2848f1b41cd30d360519"
  end

  resource "ecdsa" do
    url "https://files.pythonhosted.org/packages/source/e/ecdsa/ecdsa-0.13.tar.gz"
    sha256 "64cf1ee26d1cde3c73c6d7d107f835fed7c6a2904aef9eac223d57ad800c43fa"
  end

  resource "paramiko" do
    url "https://files.pythonhosted.org/packages/source/p/paramiko/paramiko-1.15.3.tar.gz"
    sha256 "7e17ec363c73acb0e77a5fcc6e44a0dd494339a9067e99a997a7d32b4272fef1"
  end

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python2.7/site-packages"
    resources.each do |r|
      r.stage { system "python", *Language::Python.setup_install_args(libexec/"vendor") }
    end

    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python2.7/site-packages"
    system "python", *Language::Python.setup_install_args(libexec)

    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    sshconfig_path = (testpath/"sshconfig")
    touch sshconfig_path

    system bin/"storm", "add", "--config", "sshconfig", "aliastest", "user@example.com:22"

    expected_output = <<~EOS
      Host aliastest
          hostname example.com
          user user
          port 22
    EOS
    assert_equal expected_output, sshconfig_path.read
  end
end
