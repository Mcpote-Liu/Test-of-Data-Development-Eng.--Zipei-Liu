import re, sys
from datetime import datetime, timezone
from urllib.parse import urlparse

#计算domain1为域名的数量的函数
def count_https_domain(path, domain="domain1.com"):
    c = 0
    for l in open(path, encoding="utf-8", errors="ignore"):
        p = l.split('"')
        if len(p) > 3: # 第4段通常是 Referer
            try:
                u = urlparse(p[3])
                if u.scheme == "https" and u.hostname == domain: c += 1
            except: pass
    return c

# 计算某一天请求成功比例（UTC时间）
def success_ratio(path, date_str):
    d = datetime.strptime(date_str, "%Y-%m-%d").date()
    t = s = 0
    for l in open(path, encoding="utf-8", errors="ignore"):
        m = re.search(r"\[(.*?)\]", l); n = re.search(r'"\s*(\d{3})\s+\d+', l)
        if not m or not n: continue
        if datetime.strptime(m.group(1), "%d/%b/%Y:%H:%M:%S %z").astimezone(timezone.utc).date() != d: continue
        t += 1; code = int(n.group(1))
        if 200 <= code < 400: s += 1 #认为2xx和3xx状态码均属于正确
    return t, s, s/t if t else 0

if __name__ == "__main__":
    log, day = sys.argv[1], sys.argv[2] #接受两个参数 log路径和日期date
    print("HTTPS from domain1.com:", count_https_domain(log))
    T,S,R = success_ratio(log, day)
    print(f"{day} total={T}, success={S}, ratio={R:.2%}")

#  调用方式：python q1.py access.log 2025-09-26
