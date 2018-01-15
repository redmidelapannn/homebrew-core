class CoreosCt < Formula
  desc "Convert a Container Linux Config into Ignition"
  homepage "https://coreos.com/os/docs/latest/configuration.html"
  url "https://github.com/coreos/container-linux-config-transpiler/archive/v0.5.0.tar.gz"
  sha256 "172e44796d39ec117584e121e73194cbcb56701407badc1899cea4607a343e15"

  bottle do
    cellar :any_skip_relocation
    sha256 "96fceaa1f50ed8494b28f1fb29df27e6a3c6a1e15ee56163cc5aa36795e8dc31" => :high_sierra
    sha256 "91aef878b6307cb9689703a9ab98124a6e8328b7b5c7ac81d65bcbe88678dbc7" => :sierra
    sha256 "f05308a898c131eee24e8fd82b2db3c91853af9873a93ef18cbeaef9bdbc1d3b" => :el_capitan
  end

  depends_on "go" => :build

  def install
    system "git", "init"
    system "git", "add", "-A"
    system "git", "commit", "-m", version
    system "git", "tag", "-a", "-m", version, version
    system "make", "all"
    bin.install "./bin/ct"
  end

  test do
    assert_equal "ct #{version}", shell_output("#{bin}/ct -version").chomp

    input_file = Tempfile.new("ct-input")
    input_file.write(test_input)
    input_file.close
    assert_equal test_output.strip, shell_output("#{bin}/ct -pretty -in-file #{input_file.path}").strip
  end

  def test_input; <<~EOS
    passwd:
      users:
        - name: core
          ssh_authorized_keys:
            - ssh-rsa mykey
    EOS
  end

  def test_output; <<~EOS
    {
      "ignition": {
        "config": {},
        "timeouts": {},
        "version": "2.1.0"
      },
      "networkd": {},
      "passwd": {
        "users": [
          {
            "name": "core",
            "sshAuthorizedKeys": [
              "ssh-rsa mykey"
            ]
          }
        ]
      },
      "storage": {},
      "systemd": {}
    }
    EOS
  end
end
