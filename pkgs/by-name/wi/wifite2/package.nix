{
  lib,
  fetchFromGitHub,
  python3Packages,
  wirelesstools,
  aircrack-ng,
  wireshark-cli,
  reaverwps-t6x,
  cowpatty,
  hashcat,
  hcxtools,
  hcxdumptool,
  which,
  bully,
  pixiewps,
  john,
  iw,
  iproute2,
  iptables,
  macchanger,
}:

python3Packages.buildPythonApplication rec {
  pname = "wifite2";
  version = "3.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "kimocoder";
    repo = "wifite2";
    rev = version;
    hash = "sha256-zAVZuVpl2/zR7AMkYbpUABWIcUbnUZqXaJa0DSa1VW8=";
  };

  build-system = with python3Packages; [ poetry-core ];

  dependencies = with python3Packages; [
    chardet
    requests
    rich
    scapy
    setuptools
  ];

  pythonRelaxDeps = [
    "chardet"
    "setuptools"
  ];

  propagatedBuildInputs = [
    aircrack-ng
    wireshark-cli
    reaverwps-t6x
    cowpatty
    hashcat
    hcxtools
    hcxdumptool
    wirelesstools
    which
    bully
    pixiewps
    john
    iw
    iproute2
    iptables
    macchanger
  ];

  nativeCheckInputs = propagatedBuildInputs ++ [ python3Packages.pytestCheckHook ];

  disabledTests = [
    # john-jumbo reports "1.9.0-jumbo", not the "version X.Y" format assumed here.
    "test_john_version_readable"
    # wpapsk rejects the fixture's four-character password; WPA requires eight.
    "test_crack_known_key_handshake"
  ];

  preCheck = "export HOME=$TMPDIR";

  meta = {
    homepage = "https://github.com/kimocoder/wifite2";
    description = "Rewrite of the popular wireless network auditor, wifite";
    mainProgram = "wifite";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      lassulus
      danielfullmer
    ];
  };
}
