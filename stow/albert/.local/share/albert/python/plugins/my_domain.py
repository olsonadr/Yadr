import json
import pathlib
import time
import traceback
import webbrowser
from typing import List

import albert

md_iid = "2.0"
md_version = "1.0"
md_name = "MyDomain"
md_description = "Open subdomain of your website"
md_license = "MIT"
md_url = ""
md_maintainers = "@olsonadr"

config_filename = f"{md_name}.json"
default_config = {"protocol": "https", "domain": ""}


class Plugin(albert.PluginInstance, albert.TriggerQueryHandler):

    def __init__(self):
        albert.TriggerQueryHandler.__init__(
            self,
            id=md_id,  # type: ignore
            name=md_name,
            description=md_description,
            defaultTrigger="me ",
        )
        albert.PluginInstance.__init__(self, extensions=[self])
        self.ensureConfigFileExists()

    @property
    def configFile(self) -> pathlib.Path:
        return self.configLocation / config_filename

    @property
    def protocol(self) -> str:
        return self.readConfig("protocol", str)

    @protocol.setter
    def protocol(self, value: str):
        self.writeConfig("protocol", value)

    @property
    def domain(self) -> str:
        return self.readConfig("domain", str)

    @domain.setter
    def domain(self, value: str):
        self.writeConfig("domain", value)

    def ensureConfigFileExists(self) -> None:
        """Create config file if it doesn't exist yet."""
        if not self.configFile.exists():
            self.configFile.write_text(json.dumps(default_config))

    def handleTriggerQuery(self, query):
        start_time = time.time()
        try:
            for item in _handleQuery(
                query,
                self.readConfig("protocol", str),
                self.readConfig("domain", str),
            ):
                query.add(item)
        except Exception:
            albert.debug(traceback.format_exc())
        finally:
            cost = round((time.time() - start_time) * 1000, 3)
            albert.debug(f"execute:{query.string}. cost: {cost} ms ")

    def readConfig(
        self, key: str, type: type[str] | int | float | bool
    ) -> str:
        if type != str:
            raise ValueError(
                "Only string types are supported for this plugin."
            )
        self.ensureConfigFileExists()
        return json.loads(self.configFile.read_text())[key]

    def writeConfig(self, key: str, value: str | int | float | bool) -> None:
        if type(value) is str:
            raise ValueError(
                "Only string types are supported for this plugin."
            )
        self.ensureConfigFileExists()
        (config := json.loads(self.configFile.read_text()))[key] = value
        self.configFile.write_text(json.dumps(config))

    def configWidget(self) -> List[dict]:
        return [
            {
                "type": "combobox",
                "label": "HTTP or HTTPS",
                "description": "Protocol for communicating with subdomains.",
                "property": "protocol",
                "items": ["http", "https"],
                "default": default_config["protocol"],
            },
            {
                "type": "lineedit",
                "label": "Domain",
                "description": "The domain containing the subdomains to open.",
                "property": "domain",
                "default": default_config["domain"],
            },
        ]


def _handleQuery(
    query, protocol: str, domain: str
) -> list[albert.StandardItem]:
    stripped = query.string.strip().lower()
    if not stripped:
        return []

    # For now do no filtering or pre-processing, just give one option to open
    # the currently enterred subdomain the browser.
    target_uri = f"{protocol}://{stripped}.{domain}"
    return [
        albert.StandardItem(
            id=f"MyDomain:{stripped}",
            text=stripped,
            subtext=f"Open {target_uri}",
            actions=[
                albert.Action(
                    "MyDomain",
                    "MyDomain",
                    lambda x=target_uri: webbrowser.open(x),
                ),
            ],
        )
    ]
