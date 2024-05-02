import time
import traceback

from typing import List
import webbrowser
from albert import *

domain_fmt_string = "https://%s.nicholasolson.dev"

md_iid = '2.0'
md_version = "1.0"
md_name = "MyDomain"
md_description = "Open subdomain of your website"
md_license = "MIT"
md_url = ""
md_maintainers = "@olsonadr"


class Plugin(PluginInstance, TriggerQueryHandler):

    def __init__(self):
        TriggerQueryHandler.__init__(
            self,
            id=md_id,
            name=md_name,
            description=md_description,
            defaultTrigger='me '
        )
        PluginInstance.__init__(self, extensions=[self])
        self.protocol = "https"
        self.domain = ""

    def handleTriggerQuery(self, query):
        start_time = time.time()
        try:
            for item in _handleQuery(query, self.protocol, self.domain):
                query.add(item)
        except:
            error(traceback.format_exc())
        finally:
            debug(f"execute:{query.string}. cost: {round((time.time() - start_time) * 1000, 3)} ms ")
    
    def readConfig(self, key: str, type: type[str|int|float|bool]) -> str|int|float|bool|None:
        if type != str:
            raise ValueError("Only string types are supported for this plugin.")

        match key:
            case "protocol":
                return self.protocol
            case "domain":
                return self.domain
            case _:
                return None

    def writeConfig(self, key: str, value: str|int|float|bool):
        if type != str:
            raise ValueError("Only string types are supported for this plugin.")

        match key:
            case "protocol":
                self.protocol = value
            case "domain":
                self.domain = value
            case _:
                raise ValueError(f"Invalid key: {key}")

    def configWidget(self) -> List[dict]:
        return [
            {
                "type": "combobox",
                "label": "HTTP or HTTPS",
                "description": "Which protocol for communicating with the subdomains.",
                "property": "protocol",
                "items": ["http", "https"],
                "default": self.protocol,
            },
            {
                "type": "lineedit",
                "label": "Domain",
                "description": "The domain containing the subdomains to open.",
                "property": "domain",
                "default": self.domain,
            }
        ]


def _handleQuery(query, protocol: str, domain: str) -> list[StandardItem]:
    stripped = query.string.strip().lower()
    if not stripped:
        return []

    # For now do no filtering or pre-processing, just give one option to open
    # the currently enterred subdomain the browser.
    target_uri = f"{protocol}://{stripped}.{domain}"
    return [
        StandardItem(
            id=f"MyDomain:{stripped}",
            text=stripped,
            subtext=f"Open {target_uri}",
            actions=[
                Action(
                    "MyDomain", "MyDomain", lambda x=target_uri: webbrowser.open(x),
                ),
            ],
        )
    ]
