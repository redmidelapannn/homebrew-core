class Certbot < Formula
  include Language::Python::Virtualenv

  desc "Tool to obtain certs from Let's Encrypt and autoenable HTTPS"
  homepage "https://certbot.eff.org/"
  url "https://github.com/certbot/certbot/archive/v1.1.0.tar.gz"
  sha256 "9b57d009a6ad62d21ca23b0c21c28654353a5493dd1b8b0b6953c166e7a73b3e"
  head "https://github.com/certbot/certbot.git"

  bottle do
    cellar :any
    sha256 "d3ff1f180e9048ef5d7fb7f95dbe8d04094261351815eda2408ed7343d56308a" => :catalina
    sha256 "69432acc19a087c898e085635d2523887cd323792be54d4d68fd0311937d9f5e" => :mojave
    sha256 "504eb5bfa12f607a5a71f2e8911d697b4ccfc9ee602d63ef8fbf89feeae58e48" => :high_sierra
  end

  depends_on "augeas"
  depends_on "dialog"
  depends_on "openssl@1.1"
  depends_on "python@3.8"

  resource "acme" do
    url "https://files.pythonhosted.org/packages/e4/80/07e77634199dbbe595b3b1e320adae7fcb00653dc4bf5e56f457851e8017/acme-1.1.0.tar.gz"
    sha256 "c305a20eeb9cb02240347703d497891c13d43a47c794fa100d4dbb479a5370d9"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/41/bf/9d214a5af07debc6acf7f3f257265618f1db242a3f8e49a9b516f24523a6/certifi-2019.11.28.tar.gz"
    sha256 "25b64c7da4cd7479594d035c08c2d809eb4aab3a26e5a990ea98cc450c320f1f"
  end

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/2d/bf/960e5a422db3ac1a5e612cb35ca436c3fc985ed4b7ed13a1b4879006f450/cffi-1.13.2.tar.gz"
    sha256 "599a1e8ff057ac530c9ad1778293c665cb81a791421f46922d80a86473c13346"
  end

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/fc/bb/a5768c230f9ddb03acc9ef3f0d4a3cf93462473795d18e9535498c8f929d/chardet-3.0.4.tar.gz"
    sha256 "84ab92ed1c4d4f16916e05906b6b75a6c0fb5db821cc65e70cbd64a3e2a5eaae"
  end

  resource "ConfigArgParse" do
    url "https://files.pythonhosted.org/packages/66/37/dd9fcb3b19c1dceea450ee994952e311a96dd827bb09ee19169c3427e0d3/ConfigArgParse-1.0.tar.gz"
    sha256 "bf378245bc9cdc403a527e5b7406b991680c2a530e7e81af747880b54eb57133"
  end

  resource "configobj" do
    url "https://files.pythonhosted.org/packages/64/61/079eb60459c44929e684fa7d9e2fdca403f67d64dd9dbac27296be2e0fab/configobj-5.0.6.tar.gz"
    sha256 "a2f5650770e1c87fb335af19a9b7eb73fc05ccf22144eb68db7d00cd2bcb0902"
  end

  resource "cryptography" do
    url "https://files.pythonhosted.org/packages/be/60/da377e1bed002716fb2d5d1d1cab720f298cb33ecff7bf7adea72788e4e4/cryptography-2.8.tar.gz"
    sha256 "3cda1f0ed8747339bbdf71b9f38ca74c7b592f24f65cdb3ab3765e4b02871651"
  end

  resource "distro" do
    url "https://files.pythonhosted.org/packages/ca/e3/78443d739d7efeea86cbbe0216511d29b2f5ca8dbf51a6f2898432738987/distro-1.4.0.tar.gz"
    sha256 "362dde65d846d23baee4b5c058c8586f219b5a54be1cf5fc6ff55c4578392f57"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/ad/13/eb56951b6f7950cadb579ca166e448ba77f9d24efc03edd7e55fa57d04b7/idna-2.8.tar.gz"
    sha256 "c357b3f628cf53ae2c4c05627ecc484553142ca23264e593d327bcde5e9c3407"
  end

  resource "josepy" do
    url "https://files.pythonhosted.org/packages/a4/78/297f71aafb7d4d825af43087ccf7b4a790283329b246e66d8a31b0cac093/josepy-1.2.0.tar.gz"
    sha256 "9cec9a839fe9520f0420e4f38e7219525daccce4813296627436fe444cd002d3"
  end

  resource "mock" do
    url "https://files.pythonhosted.org/packages/2e/ab/4fe657d78b270aa6a32f027849513b829b41b0f28d9d8d7f8c3d29ea559a/mock-3.0.5.tar.gz"
    sha256 "83657d894c90d5681d62155c82bda9c1187827525880eda8ff5df4ec813437c3"
  end

  resource "parsedatetime" do
    url "https://files.pythonhosted.org/packages/5f/19/43357ced106dd1ab6bceb1decb866e8619172fc271991a54eb2f680a2e9b/parsedatetime-2.5.tar.gz"
    sha256 "d2e9ddb1e463de871d32088a3f3cea3dc8282b1b2800e081bd0ef86900451667"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/68/9e/49196946aee219aead1290e00d1e7fdeab8567783e83e1b9ab5585e6206a/pycparser-2.19.tar.gz"
    sha256 "a988718abfad80b6b157acce7bf130a30876d27603738ac39f140993246b25b3"
  end

  resource "pyOpenSSL" do
    url "https://files.pythonhosted.org/packages/0d/1d/6cc4bd4e79f78be6640fab268555a11af48474fac9df187c3361a1d1d2f0/pyOpenSSL-19.1.0.tar.gz"
    sha256 "9a24494b2602aaf402be5c9e30a0b82d4a5c67528fe8fb475e3f3bc00dd69507"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/a2/56/0404c03c83cfcca229071d3c921d7d79ed385060bbe969fde3fd8f774ebd/pyparsing-2.4.6.tar.gz"
    sha256 "4c830582a84fb022400b85429791bc551f1f4871c33f23e44f353119e92f969f"
  end

  resource "pyRFC3339" do
    url "https://files.pythonhosted.org/packages/00/52/75ea0ae249ba885c9429e421b4f94bc154df68484847f1ac164287d978d7/pyRFC3339-1.1.tar.gz"
    sha256 "81b8cbe1519cdb79bed04910dd6fa4e181faf8c88dff1e1b987b5f7ab23a5b1a"
  end

  resource "python-augeas" do
    url "https://files.pythonhosted.org/packages/b4/d7/62d335d9df28e2f78207dcd12bbbcee89a7b5ba6d247feaddc9d04f27e1e/python-augeas-1.0.3.tar.gz"
    sha256 "d062f4a44aee797aa9296f5a82cd8c3df5036ca23df6b9ac48cbaa3b4f29a664"
  end

  resource "pytz" do
    url "https://files.pythonhosted.org/packages/82/c3/534ddba230bd4fbbd3b7a3d35f3341d014cca213f369a9940925e7e5f691/pytz-2019.3.tar.gz"
    sha256 "b02c06db6cf09c12dd25137e563b31700d3b80fcc4ad23abb7a315f2789819be"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/01/62/ddcf76d1d19885e8579acb1b1df26a852b03472c0e46d2b959a714c90608/requests-2.22.0.tar.gz"
    sha256 "11e007a8a2aa0323f5a921e9e6a2d7e4e67d9877e85773fba9ba6419025cbeb4"
  end

  resource "requests-toolbelt" do
    url "https://files.pythonhosted.org/packages/28/30/7bf7e5071081f761766d46820e52f4b16c8a08fef02d2eb4682ca7534310/requests-toolbelt-0.9.1.tar.gz"
    sha256 "968089d4584ad4ad7c171454f0a5c6dac23971e9472521ea3b6d49d610aa6fc0"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/21/9f/b251f7f8a76dec1d6651be194dfba8fb8d7781d10ab3987190de8391d08e/six-1.14.0.tar.gz"
    sha256 "236bdbdce46e6e6a3d61a337c0f8b763ca1e8717c03b369e87a7ec7ce1319c0a"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/09/06/3bc5b100fe7e878d3dee8f807a4febff1a40c213d2783e3246edde1f3419/urllib3-1.25.8.tar.gz"
    sha256 "87716c2d2a7121198ebcb7ce7cccf6ce5e9ba539041cfbaeecfb641dc0bf6acc"
  end

  resource "zope.component" do
    url "https://files.pythonhosted.org/packages/32/97/81ce1c228e8a7e98ef92e8ff211b091cf5a223d6d69cb599368798084042/zope.component-4.6.tar.gz"
    sha256 "ec2afc5bbe611dcace98bb39822c122d44743d635dafc7315b9aef25097db9e6"
  end

  resource "zope.deferredimport" do
    url "https://files.pythonhosted.org/packages/b9/74/6eb2dcf013fac35d086abef2435b5a6621435c2b0c166ef5b63a1b51e91d/zope.deferredimport-4.3.1.tar.gz"
    sha256 "57b2345e7b5eef47efcd4f634ff16c93e4265de3dcf325afc7315ade48d909e1"
  end

  resource "zope.deprecation" do
    url "https://files.pythonhosted.org/packages/34/da/46e92d32d545dd067b9436279d84c339e8b16de2ca393d7b892bc1e1e9fd/zope.deprecation-4.4.0.tar.gz"
    sha256 "0d453338f04bacf91bbfba545d8bcdf529aa829e67b705eac8c1a7fdce66e2df"
  end

  resource "zope.event" do
    url "https://files.pythonhosted.org/packages/4c/b2/51c0369adcf5be2334280eed230192ab3b03f81f8efda9ddea6f65cc7b32/zope.event-4.4.tar.gz"
    sha256 "69c27debad9bdacd9ce9b735dad382142281ac770c4a432b533d6d65c4614bcf"
  end

  resource "zope.hookable" do
    url "https://files.pythonhosted.org/packages/35/7e/d7ffdd410a9b4aa97d175af1718baa6b741ec6a60baa668354dd3da4e26c/zope.hookable-5.0.0.tar.gz"
    sha256 "0f325838dbac827a1e2ed5d482c1f2656b6844dc96aa098f7727e76395fcd694"
  end

  resource "zope.interface" do
    url "https://files.pythonhosted.org/packages/c3/05/bf3130eb799548882ce61b7c3d2dbc5d4d5cc6e821efa8786c5273d56844/zope.interface-4.7.1.tar.gz"
    sha256 "4bb937e998be9d5e345f486693e477ba79e4344674484001a0b646be1d530487"
  end

  resource "zope.proxy" do
    url "https://files.pythonhosted.org/packages/e2/44/bea546c55488c044351e51ebf23bf440b19876e0069a418cadc1bd5736f7/zope.proxy-4.3.3.tar.gz"
    sha256 "dac4279aa05055d3897ab5e5ee5a7b39db121f91df65a530f8b1ac7f9bd93119"
  end

  def install
    xy = Language::Python.major_minor_version "python3"
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python#{xy}/site-packages"
    resources.each do |r|
      r.stage do
        system "python3", *Language::Python.setup_install_args(libexec/"vendor")
      end
    end

    # Install in our prefix, not the first-in-the-path python site-packages dir.
    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python#{xy}/site-packages"

    cd buildpath/"certbot" do
      system "python3", *Language::Python.setup_install_args(libexec)
    end

    # Shipped with certbot, not external resources.
    %w[acme certbot-apache certbot-nginx].each do |r|
      cd buildpath/r do
        system "python3", *Language::Python.setup_install_args(libexec/"vendor")
      end
    end
    pkgshare.install buildpath/"certbot/examples"

    bin.install Dir[libexec/"bin/certbot"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    assert_match version.to_s, pipe_output("#{bin}/certbot --version 2>&1")
    # This throws a bad exit code but we can check it actually is failing
    # for the right reasons by asserting. --version never fails even if
    # resources are missing or outdated/too new/etc.
    assert_match "Either run as root", shell_output("#{bin}/certbot 2>&1", 1)
  end
end
