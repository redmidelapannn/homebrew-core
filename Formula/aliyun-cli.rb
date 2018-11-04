class AliyunCli < Formula
  desc "Universal Command-line Interface for Alibaba Cloud"
  homepage "https://github.com/aliyun/aliyun-cli"
  url "https://github.com/aliyun/aliyun-cli/archive/v3.0.5.tar.gz"
  sha256 "fa9a9e736f3a02c454695b75e0dd1e7c140fba63d114537d24babd0b6930f99a"

  depends_on "go" => :build
  depends_on "go-bindata" => :build

  def install
    ENV["GOPATH"] = buildpath

    dir = buildpath/"src/github.com/aliyun/aliyun-cli"
    dir.install buildpath.children - [buildpath/".brew_home"]

    cd dir do
      system "make", "clean", "deps", "build"
      bin.install "out/aliyun"
    end
  end

  test do
    minimal = testpath/".aliyun/config.json"
    minimal.write <<~EOS
      {
        "current": "default",
        "profiles": [
            {
                "name": "default",
                "mode": "AK",
                "access_key_id": "fooo",
                "access_key_secret": "baaar",
                "sts_token": "",
                "ram_role_name": "",
                "ram_role_arn": "",
                "ram_session_name": "",
                "private_key": "",
                "key_pair_name": "",
                "expired_seconds": 0,
                "verified": "",
                "region_id": "eu-central-1",
                "output_format": "json",
                "language": "en",
                "site": "",
                "retry_timeout": 0,
                "retry_count": 0
            }
        ],
        "meta_path": ""
      }
    EOS

    expected = "Profile   | Credential         | Valid   | Region           | Language\n"\
                "--------- | ------------------ | ------- | ---------------- | --------\n"\
                "default * | AK:***ooo          | Valid   | eu-central-1     | en\n"

    result = shell_output("#{bin}/aliyun configure list")
    assert_equal expected, result
  end
end
