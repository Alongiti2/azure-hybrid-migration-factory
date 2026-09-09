# Contoso Manufacturing
# Customer Discovery & Environment Assessment Questionnaire

## Engagement
Azure Hybrid Migration Factory

## Consultant Role
Senior Azure Technical Migration Consultant

## Source Platforms
- Azure Stack Hub
- Azure Stack Edge
- On-premises infrastructure
- Supporting enterprise services

## Target Platforms Under Consideration
- Microsoft Azure
- Azure Local
- Azure Arc

---

# 1. Business and Migration Objectives

1. What are the primary business drivers for this migration?
2. Why is Contoso considering migration now?
3. What business outcomes are expected?
4. What applications are considered business critical?
5. Which business units depend on the source environment?
6. What is the desired completion date?
7. Are there regulatory deadlines?
8. Are there hardware lifecycle deadlines?
9. Are there contract or licensing deadlines?
10. Are there cost-reduction objectives?
11. Is modernization part of the migration objective?
12. Is datacenter exit part of the objective?
13. Is improved resiliency a business goal?
14. Is security improvement a major driver?
15. Is operational simplification a major driver?

# 2. Stakeholders and Governance

16. Who is the executive sponsor?
17. Who owns the migration program?
18. Who is the technical decision maker?
19. Who owns the Azure environment?
20. Who owns Azure Stack Hub?
21. Who owns Azure Stack Edge?
22. Who owns networking?
23. Who owns identity?
24. Who owns cybersecurity?
25. Who owns applications?
26. Who owns databases?
27. Who owns backup and disaster recovery?
28. Who approves production changes?
29. Who provides final business signoff?
30. What is the escalation path?

# 3. Application Inventory

31. How many applications exist in scope?
32. What is the name of each application?
33. Who owns each application?
34. What business process does each application support?
35. What is the business criticality?
36. What are the application tiers?
37. Is the application web-based?
38. Is the application client-server?
39. Is the application API-based?
40. Is the application containerized?
41. Is the application vendor supported?
42. Is the application custom developed?
43. What programming language is used?
44. What application framework is used?
45. What runtime versions are used?
46. What middleware is required?
47. What certificates are required?
48. What ports are required?
49. What external services are required?
50. What authentication mechanism is used?
51. Does the application require Active Directory?
52. Does the application require Microsoft Entra ID?
53. Does the application use service accounts?
54. Does the application use hard-coded credentials?
55. Does the application use local accounts?
56. What are the application dependencies?
57. What applications must migrate together?
58. What applications cannot tolerate downtime?
59. What applications require redesign?
60. What applications are candidates for retirement?

# 4. Server and VM Inventory

61. How many VMs exist?
62. What is the hostname of each VM?
63. What operating system is installed?
64. What OS version is installed?
65. Is the OS vendor supported?
66. What is the VM CPU configuration?
67. How much RAM is assigned?
68. How much storage is attached?
69. What disk types are used?
70. What is average CPU utilization?
71. What is peak CPU utilization?
72. What is average memory utilization?
73. What is peak memory utilization?
74. What is average disk IOPS?
75. What is peak disk IOPS?
76. What is the average network throughput?
77. What availability requirements exist?
78. Are VMs clustered?
79. Are there availability sets or equivalent constructs?
80. Are there anti-affinity requirements?
81. Are any VMs dependent on specialized hardware?
82. Are any workloads GPU dependent?
83. Are any workloads latency sensitive?
84. Are any servers unsupported or end-of-life?
85. Are any physical servers in scope?

# 5. Azure Stack Hub Discovery

86. What Azure Stack Hub version is deployed?
87. Is the deployment connected or disconnected?
88. What identity provider is used?
89. Which resource providers are deployed?
90. Which Azure services are currently available?
91. How many subscriptions exist?
92. How many tenants exist?
93. What regions are configured?
94. What VM sizes are used?
95. What storage services are in use?
96. What networking services are in use?
97. Are load balancers configured?
98. Are public IP addresses used?
99. What quotas are configured?
100. What marketplace items are deployed?
101. Are custom images used?
102. What patches are currently installed?
103. What management tools are used?
104. What monitoring is configured?
105. What backup solution is used?
106. What known platform issues exist?

# 6. Azure Stack Edge Discovery

107. What Azure Stack Edge model is deployed?
108. What software version is installed?
109. What edge workloads are running?
110. Are virtual machines running on the device?
111. Are containers running on the device?
112. Are Kubernetes workloads running?
113. Is machine learning inference performed?
114. What local storage is used?
115. How much data is stored locally?
116. What data must remain at the edge?
117. What data is uploaded to Azure?
118. What network connectivity exists?
119. What bandwidth limitations exist?
120. What latency limitations exist?
121. Are workloads location dependent?
122. Are workloads hardware accelerated?
123. Are there offline operation requirements?
124. Are there regulatory data-residency requirements?
125. Are there physical security requirements?

# 7. Database Discovery

126. What database platforms are used?
127. What database versions are installed?
128. What databases are production critical?
129. What is the size of each database?
130. What is the database growth rate?
131. What are the peak transaction rates?
132. What are the latency requirements?
133. What applications connect to each database?
134. What authentication method is used?
135. Is encryption at rest enabled?
136. Is encryption in transit enabled?
137. Are database backups configured?
138. How often are backups taken?
139. Are backups tested?
140. Are database replicas configured?
141. Are clustering technologies used?
142. Are there cross-database dependencies?
143. Are stored procedures heavily used?
144. Are linked servers configured?
145. Are there licensing restrictions?
146. What RPO is required?
147. What RTO is required?

# 8. Storage Discovery

148. What storage platforms are used?
149. What storage capacity exists?
150. How much capacity is currently consumed?
151. What is the annual growth rate?
152. What storage protocols are used?
153. Is SMB used?
154. Is NFS used?
155. Is iSCSI used?
156. Is object storage used?
157. Are storage snapshots configured?
158. Is storage replicated?
159. What performance requirements exist?
160. What IOPS requirements exist?
161. What throughput requirements exist?
162. What latency requirements exist?
163. What data classification applies?
164. What data must remain on-premises?
165. What data can move to Azure?
166. What retention requirements exist?

# 9. Network Discovery

167. What IP address ranges exist?
168. What subnets exist?
169. What VLANs exist?
170. What VNets exist?
171. Are any IP ranges overlapping?
172. What routing protocols are used?
173. What static routes exist?
174. What default routes exist?
175. What firewalls are deployed?
176. What firewall rules are required?
177. What NSGs exist?
178. What load balancers exist?
179. What proxies exist?
180. What NAT configuration exists?
181. What DNS servers are used?
182. What DNS zones exist?
183. Are split-brain DNS configurations used?
184. What DHCP infrastructure exists?
185. What VPN connections exist?
186. Is ExpressRoute used?
187. What bandwidth is available to Azure?
188. What is the average WAN utilization?
189. What is the peak WAN utilization?
190. What latency exists between sites?
191. What private endpoints are required?
192. What ingress traffic is required?
193. What egress traffic is required?
194. What ports must remain open?
195. Are there network segmentation requirements?
196. Are there zero-trust requirements?

# 10. Identity Discovery

197. Is Active Directory used?
198. How many AD forests exist?
199. How many AD domains exist?
200. What domain functional levels are used?
201. Where are domain controllers located?
202. Is Microsoft Entra ID used?
203. Is Entra Connect deployed?
204. Is federation used?
205. Is AD FS used?
206. Is MFA enforced?
207. Is Conditional Access configured?
208. Are privileged accounts separated?
209. Is Privileged Identity Management used?
210. Are managed identities used?
211. Are service principals used?
212. How are service account passwords managed?
213. Are legacy authentication protocols enabled?
214. Are there LDAP dependencies?
215. Are there Kerberos dependencies?
216. Are there NTLM dependencies?
217. Are there certificate-based authentication dependencies?
218. Are external identities used?
219. Are B2B users present?
220. What RBAC model exists?

# 11. Security Discovery

221. What cybersecurity standards apply?
222. What security policies apply?
223. Is Microsoft Defender used?
224. Is a SIEM platform deployed?
225. Is Microsoft Sentinel used?
226. What EDR solution is used?
227. What vulnerability management platform is used?
228. How are vulnerabilities remediated?
229. What patch-management system is used?
230. What encryption standards are required?
231. Where are encryption keys stored?
232. Is Key Vault used?
233. What secrets-management solution exists?
234. Are certificates centrally managed?
235. How are privileged accounts monitored?
236. What logging is required?
237. What security logs are retained?
238. How long are security logs retained?
239. What incident-response procedures exist?
240. Are penetration tests performed?
241. Are compliance audits performed?
242. Are there data-loss-prevention requirements?
243. Are there regulatory data-residency requirements?
244. Are there customer contractual security requirements?

# 12. Backup Discovery

245. What backup platform is used?
246. What systems are backed up?
247. How frequently are backups taken?
248. How long are backups retained?
249. Where are backups stored?
250. Are backups encrypted?
251. Are backups immutable?
252. Are offline backups maintained?
253. When was the last restore test?
254. Was the restore successful?
255. What systems have never been restore tested?
256. What application-consistent backups are required?
257. What database-consistent backups are required?
258. What backup failures currently exist?

# 13. Disaster Recovery

259. Is a formal DR plan documented?
260. When was the DR plan last tested?
261. What applications have DR capability?
262. What applications do not have DR capability?
263. What is the business RTO?
264. What is the business RPO?
265. What is the technical RTO?
266. What is the technical RPO?
267. Where is the DR site located?
268. Is replication synchronous or asynchronous?
269. What failover process exists?
270. What failback process exists?
271. Who declares a disaster?
272. Who approves failover?
273. How is DR tested?
274. Are DR tests documented?

# 14. Monitoring and Operations

275. What monitoring platform is used?
276. Is Azure Monitor used?
277. Is Log Analytics used?
278. What metrics are collected?
279. What logs are collected?
280. What alerts exist?
281. Who receives alerts?
282. Is 24x7 monitoring available?
283. Are dashboards configured?
284. What application monitoring exists?
285. What database monitoring exists?
286. What infrastructure monitoring exists?
287. What network monitoring exists?
288. What security monitoring exists?
289. What operational runbooks exist?
290. What on-call model exists?

# 15. Compliance and Legal

291. What regulations apply?
292. Does PCI DSS apply?
293. Does HIPAA apply?
294. Does SOX apply?
295. Does GDPR apply?
296. Are export-control restrictions applicable?
297. Are data-sovereignty restrictions applicable?
298. What data-retention policies apply?
299. What legal-hold requirements apply?
300. Are there contractual hosting restrictions?
301. Are audit logs legally required?
302. Are there geographic restrictions on data storage?

# 16. Migration Constraints

303. What systems cannot be migrated?
304. What systems cannot be shut down?
305. What migration windows are available?
306. What blackout periods exist?
307. What change freezes exist?
308. What maximum downtime is acceptable?
309. What network constraints exist?
310. What licensing constraints exist?
311. What vendor-support constraints exist?
312. What legacy dependencies exist?
313. What hardware dependencies exist?
314. What application dependencies exist?
315. What business-season constraints exist?
316. Are there production freeze dates?
317. Are there regulatory approval requirements?
318. Are there executive approval requirements?

# 17. Migration Readiness

319. Is the workload technically supported in the target?
320. Is the operating system supported?
321. Is the application supported?
322. Is the database supported?
323. Is networking ready?
324. Is identity ready?
325. Is security ready?
326. Is monitoring ready?
327. Is backup ready?
328. Is disaster recovery ready?
329. Are dependencies documented?
330. Has rollback been defined?
331. Has rollback been tested?
332. Have RTO/RPO requirements been validated?
333. Has the business owner approved migration?
334. Has the technical owner approved migration?

# 18. Migration Wave Planning

335. Which workloads are low risk?
336. Which workloads are medium risk?
337. Which workloads are high risk?
338. Which workloads should be used for the pilot?
339. Which applications must move together?
340. Which applications must remain together?
341. Which applications can move independently?
342. What workloads should move in Wave 1?
343. What workloads should move in Wave 2?
344. What workloads should move in Wave 3?
345. What workloads should move last?
346. What workloads should remain on Azure Local?
347. What workloads should move directly to Azure?
348. What workloads require modernization?

# 19. Validation

349. What defines migration success?
350. What application tests are required?
351. What database tests are required?
352. What network tests are required?
353. What identity tests are required?
354. What security tests are required?
355. What performance tests are required?
356. What business validation is required?
357. Who performs technical validation?
358. Who performs business validation?
359. Who provides final signoff?

# 20. Rollback

360. What conditions trigger rollback?
361. Who has authority to initiate rollback?
362. What is the maximum rollback decision time?
363. What recovery point will be used?
364. How will source systems be restored?
365. How will DNS be restored?
366. How will traffic be redirected?
367. How will database changes be reconciled?
368. How will rollback communications be handled?
369. How long will the source environment remain available?
370. When can the source environment be decommissioned?

---

# Discovery Exit Criteria

Discovery is complete when:

- Application inventory is complete
- Server inventory is complete
- Database inventory is complete
- Storage inventory is complete
- Network inventory is complete
- Identity inventory is complete
- Security inventory is complete
- Backup inventory is complete
- DR inventory is complete
- Dependencies are documented
- Business owners are identified
- RTO/RPO requirements are approved
- Migration constraints are documented
- Initial migration risks are documented