(self.webpackChunk_N_E=self.webpackChunk_N_E||[]).push([[2436],{10814:function(e,r,n){Promise.resolve().then(n.bind(n,54304))},20255:function(e,r,n){"use strict";n.d(r,{u:function(){return A}});var t=n(36164),s=n(3546),l=n(11978),i=n(84381),a=n(94909),o=n(5493),d=n(2578),c=n(40055),u=n(23782),x=n(43240),m=n(18500),h=n(11634),p=n(70410),f=n(57288),j=n(73460),v=n(31458),g=n(95052),b=n(98150),N=n(81565),y=n(82394),C=n(54594),w=n(11208),I=n(94770),z=n(10221);let k=(0,x.BX)("\n  mutation testLdapConnection($input: UpdateLdapCredentialInput!) {\n    testLdapConnection(input: $input)\n  }\n"),_=(0,x.BX)("\n  mutation updateLdapCredential($input: UpdateLdapCredentialInput!) {\n    updateLdapCredential(input: $input)\n  }\n"),O=(0,x.BX)("\n  mutation deleteLdapCredential {\n    deleteLdapCredential\n  }\n"),S=u.Ry({host:u.Z_(),port:u.oQ.number({required_error:"Required",invalid_type_error:"Invalid port"}),bindDn:u.Z_(),bindPassword:u.Z_().optional(),baseDn:u.Z_(),userFilter:u.Z_(),encryption:u.jb(m.y),skipTlsVerify:u.O7(),emailAttribute:u.Z_(),nameAttribute:u.Z_().optional()}),G="LDAP provider already exists and cannot be created again.";function A(e){let{className:r,isNew:n,defaultValues:u,onSuccess:x,existed:A,...D}=e,L=(0,l.useRouter)(),P=(0,c.m8)(),T=s.useRef(null),[q,X]=s.useState(!1),R=s.useMemo(()=>({...u||{}}),[]),[Z,U]=s.useState(!1),[V,B]=s.useState(!1),E=(0,o.cI)({resolver:(0,i.F)(S),defaultValues:R}),J=!(0,a.Z)(E.formState.dirtyFields),W=E.formState.isValid,{isSubmitting:$}=E.formState,M=()=>{L.replace("/settings/sso")},F=(0,h.Db)(_,{onCompleted(e){(null==e?void 0:e.updateLdapCredential)&&(null==x||x(E.getValues()))},form:E}),Y=(0,h.Db)(k,{onError(e){d.A.error(e.message)},onCompleted(e){(null==e?void 0:e.testLdapConnection)?d.A.success("LDAP connection test success.",{className:"mb-10"}):d.A.error("LDAP connection test failed.")}}),Q=(0,h.Db)(O),H=async e=>{if(n){let e=await P.query(p.wz,{}).then(e=>{var r;return!!(null==e?void 0:null===(r=e.data)||void 0===r?void 0:r.ldapCredential)});if(e){E.setError("root",{message:G});return}}return F({input:e})},K=s.useMemo(()=>{if(!n)return Array(36).fill("*").join("")},[n]);return(0,t.jsx)(b.l0,{...E,children:(0,t.jsxs)("div",{className:(0,f.cn)("grid gap-2",r),...D,children:[A&&(0,t.jsx)("div",{className:"mt-2 text-sm font-medium text-destructive",children:G}),(0,t.jsxs)("form",{className:"mt-6 grid gap-4",onSubmit:E.handleSubmit(H),ref:T,children:[(0,t.jsxs)("div",{children:[(0,t.jsx)(z.D,{children:"LDAP provider information"}),(0,t.jsx)(b.pf,{children:"The information is provided by your identity provider."})]}),(0,t.jsxs)("div",{className:"flex flex-col gap-6 lg:flex-row",children:[(0,t.jsx)(b.Wi,{control:E.control,name:"host",render:e=>{let{field:r}=e;return(0,t.jsxs)(b.xJ,{children:[(0,t.jsx)(b.lX,{required:!0,children:"Host"}),(0,t.jsx)(b.NI,{children:(0,t.jsx)(y.I,{placeholder:"e.g. ldap.example.com",autoCapitalize:"none",autoComplete:"off",autoCorrect:"off",className:"w-80 min-w-max",...r})}),(0,t.jsx)(b.zG,{})]})}}),(0,t.jsx)(b.Wi,{control:E.control,name:"port",render:e=>{let{field:r}=e;return(0,t.jsxs)(b.xJ,{children:[(0,t.jsx)(b.lX,{required:!0,children:"Port"}),(0,t.jsx)(b.NI,{children:(0,t.jsx)(y.I,{placeholder:"e.g. 3890",autoCapitalize:"none",autoComplete:"off",autoCorrect:"off",className:"w-80 min-w-max",...r})}),(0,t.jsx)(b.zG,{})]})}})]}),(0,t.jsxs)("div",{className:"flex flex-col gap-6 lg:flex-row",children:[(0,t.jsx)(b.Wi,{control:E.control,name:"bindDn",render:e=>{let{field:r}=e;return(0,t.jsxs)(b.xJ,{children:[(0,t.jsx)(b.lX,{required:!0,children:"Bind DN"}),(0,t.jsx)(b.NI,{children:(0,t.jsx)(y.I,{placeholder:"e.g. uid=system,ou=Users,dc=example,dc=com",autoCapitalize:"none",autoComplete:"off",autoCorrect:"off",className:"w-80 min-w-max",...r})}),(0,t.jsx)(b.zG,{})]})}}),(0,t.jsx)(b.Wi,{control:E.control,name:"bindPassword",render:e=>{let{field:r}=e;return(0,t.jsxs)(b.xJ,{children:[(0,t.jsx)(b.lX,{required:n,children:"Bind Password"}),(0,t.jsx)(b.NI,{children:(0,t.jsx)(y.I,{className:(0,f.cn)("w-80 min-w-max",{"placeholder:translate-y-[10%] !placeholder-foreground/50":!n}),placeholder:K,autoCapitalize:"none",autoComplete:"off",autoCorrect:"off",type:"password",...r})}),(0,t.jsx)(b.zG,{})]})}})]}),(0,t.jsx)(b.Wi,{control:E.control,name:"baseDn",render:e=>{let{field:r}=e;return(0,t.jsxs)(b.xJ,{children:[(0,t.jsx)(b.lX,{required:!0,children:"Base DN"}),(0,t.jsx)(b.NI,{children:(0,t.jsx)(y.I,{placeholder:"e.g. ou=Users,dc=example,dc=com",autoCapitalize:"none",autoComplete:"off",autoCorrect:"off",className:"w-80 min-w-max",...r})}),(0,t.jsx)(b.zG,{})]})}}),(0,t.jsx)(b.Wi,{control:E.control,name:"userFilter",render:e=>{let{field:r}=e;return(0,t.jsxs)(b.xJ,{children:[(0,t.jsx)(b.lX,{required:!0,children:"User Filter"}),(0,t.jsx)(b.NI,{children:(0,t.jsx)(y.I,{placeholder:"e.g. (uid=%s)",autoCapitalize:"none",autoComplete:"off",autoCorrect:"off",className:"w-80 min-w-max",...r})}),(0,t.jsx)(b.zG,{})]})}}),(0,t.jsx)(b.Wi,{control:E.control,name:"encryption",render:e=>{let{field:r}=e;return(0,t.jsxs)(b.xJ,{children:[(0,t.jsx)(b.lX,{required:!0,children:"Encryption"}),(0,t.jsxs)(C.Ph,{onValueChange:r.onChange,defaultValue:r.value,name:r.name,children:[(0,t.jsx)(b.NI,{children:(0,t.jsx)(C.i4,{className:"w-80 min-w-max",children:(0,t.jsx)(C.ki,{placeholder:"Select an encryption"})})}),(0,t.jsxs)(C.Bw,{children:[(0,t.jsx)(C.Ql,{value:m.y.None,children:"NONE"}),(0,t.jsx)(C.Ql,{value:m.y.StartTls,children:"STARTTLS"}),(0,t.jsx)(C.Ql,{value:m.y.Ldaps,children:"LDAPS"})]})]}),(0,t.jsx)(b.zG,{})]})}}),(0,t.jsx)(b.Wi,{control:E.control,name:"skipTlsVerify",render:e=>{let{field:r}=e;return(0,t.jsxs)(b.xJ,{children:[(0,t.jsx)(b.lX,{children:"Connection security"}),(0,t.jsxs)("div",{className:"flex items-center gap-1",children:[(0,t.jsx)(b.NI,{children:(0,t.jsx)(g.X,{checked:r.value,onCheckedChange:r.onChange})}),(0,t.jsx)(b.lX,{className:"cursor-pointer",children:"Skip TLS Verify"})]}),(0,t.jsx)(b.zG,{})]})}}),(0,t.jsxs)("div",{className:"mt-4",children:[(0,t.jsx)(z.D,{children:"User information mapping"}),(0,t.jsx)(b.pf,{children:"Maps the field names from user info API to the Tabby user."})]}),(0,t.jsx)(b.Wi,{control:E.control,name:"emailAttribute",render:e=>{let{field:r}=e;return(0,t.jsxs)(b.xJ,{children:[(0,t.jsx)(b.lX,{required:!0,children:"Email"}),(0,t.jsx)(b.NI,{children:(0,t.jsx)(y.I,{autoCapitalize:"none",autoComplete:"off",autoCorrect:"off",className:"w-80 min-w-max",placeholder:"e.g. email",...r})}),(0,t.jsx)(b.zG,{})]})}}),(0,t.jsx)(b.Wi,{control:E.control,name:"nameAttribute",render:e=>{let{field:r}=e;return(0,t.jsxs)(b.xJ,{children:[(0,t.jsx)(b.lX,{children:"Name"}),(0,t.jsx)(b.NI,{children:(0,t.jsx)(y.I,{autoCapitalize:"none",autoComplete:"off",autoCorrect:"off",className:"w-80 min-w-max",placeholder:"e.g. name",...r})}),(0,t.jsx)(b.zG,{})]})}}),(0,t.jsx)(w.Z,{className:"my-2"}),(0,t.jsxs)("div",{className:"flex flex-col gap-4 sm:flex-row sm:justify-between",children:[(0,t.jsxs)(v.z,{onClick:()=>{T.current&&E.trigger().then(e=>{if(e)return X(!0),Y({input:S.parse(E.getValues())}).finally(()=>{X(!1)})})},type:"button",variant:"outline",disabled:n&&!W||q,children:["Test Connection",q&&(0,t.jsx)(N.IconSpinner,{className:"mr-2 h-4 w-4 animate-spin"})]}),(0,t.jsxs)("div",{className:"flex items-center justify-end gap-4 sm:justify-start",children:[(0,t.jsx)(v.z,{type:"button",variant:"ghost",onClick:M,children:"Back"}),!n&&(0,t.jsxs)(j.aR,{open:Z,onOpenChange:U,children:[(0,t.jsx)(j.vW,{asChild:!0,children:(0,t.jsx)(v.z,{variant:"hover-destructive",children:"Delete"})}),(0,t.jsxs)(j._T,{children:[(0,t.jsxs)(j.fY,{children:[(0,t.jsx)(j.f$,{children:"Are you absolutely sure?"}),(0,t.jsx)(j.yT,{children:"This action cannot be undone. It will permanently delete the current credential."})]}),(0,t.jsxs)(j.xo,{children:[(0,t.jsx)(j.le,{children:"Cancel"}),(0,t.jsxs)(j.OL,{className:(0,v.d)({variant:"destructive"}),onClick:e=>{e.preventDefault(),B(!0),Q().then(e=>{var r,n;(null==e?void 0:null===(r=e.data)||void 0===r?void 0:r.deleteLdapCredential)?M():(B(!1),(null==e?void 0:e.error)&&d.A.error(null==e?void 0:null===(n=e.error)||void 0===n?void 0:n.message))})},children:[V&&(0,t.jsx)(N.IconSpinner,{className:"mr-2 h-4 w-4 animate-spin"}),"Yes, delete it"]})]})]})]}),(0,t.jsx)(I.M,{licenses:[m.oj.Enterprise],children:e=>{let{hasValidLicense:r}=e;return(0,t.jsxs)(v.z,{type:"submit",disabled:!r||$||!n&&!J,children:[$&&(0,t.jsx)(N.IconSpinner,{className:"mr-2 h-4 w-4 animate-spin"}),n?"Create":"Update"]})}})]})]})]}),(0,t.jsx)(b.zG,{className:"text-center"})]})})}},7846:function(e,r,n){"use strict";n.d(r,{ZP:function(){return L}});var t=n(36164),s=n(3546),l=n(11978),i=n(84381),a=n(94909),o=n(5493),d=n(2578),c=n(40055),u=n(23782),x=n(43240),m=n(18500),h=n(11634),p=n(70410),f=n(57288),j=n(73460),v=n(31458),g=n(98150),b=n(81565),N=n(82394),y=n(5266),C=n(80363),w=n(11208),I=n(48537),z=n(94770),k=n(10221);let _=(0,x.BX)("\n  mutation updateOauthCredential($input: UpdateOAuthCredentialInput!) {\n    updateOauthCredential(input: $input)\n  }\n"),O=(0,x.BX)("\n  mutation deleteOauthCredential($provider: OAuthProvider!) {\n    deleteOauthCredential(provider: $provider)\n  }\n"),S=(0,x.BX)("\n  query OAuthCallbackUrl($provider: OAuthProvider!) {\n    oauthCallbackUrl(provider: $provider)\n  }\n"),G=u.Ry({clientId:u.Z_(),clientSecret:u.Z_(),provider:u.jb(m.O4)}),A=G.extend({clientSecret:u.Z_().optional()}),D="Provider already exists. Please choose another one";function L(e){let{className:r,isNew:n,defaultProvider:x,defaultValues:L,onSuccess:P,existedProviders:T,...q}=e,X=(0,l.useRouter)(),R=(0,c.m8)(),Z=s.useMemo(()=>({...L||{},provider:x||m.O4.Github}),[]),[U,V]=s.useState(!1),[B,E]=s.useState(!1),J=s.useMemo(()=>n?G.extend({provider:u.jb(m.O4).refine(e=>!(null==T?void 0:T.includes(e)),{message:D})}):A,[n,T]),W=(0,o.cI)({resolver:(0,i.F)(J),defaultValues:Z}),$=W.watch("provider"),M=!(0,a.Z)(W.formState.dirtyFields),{isSubmitting:F}=W.formState,Y=()=>{X.replace("/settings/sso")},Q=(0,h.Db)(_,{onCompleted(e){(null==e?void 0:e.updateOauthCredential)&&(null==P||P(W.getValues()))},form:W}),H=W.watch("provider");s.useEffect(()=>{n&&(H&&(null==T?void 0:T.includes(H))?W.setError("provider",{message:D}):W.clearErrors("provider"))},[H,n,T]);let K=(0,h.Db)(O),ee=async e=>{if(n){let r=await R.query(p.Ry,{provider:e.provider}).then(e=>{var r;return!!(null==e?void 0:null===(r=e.data)||void 0===r?void 0:r.oauthCredential)});if(r){W.setError("provider",{message:D});return}}Q({input:e})},[{data:er}]=(0,c.aM)({query:S,variables:{provider:$}}),en=s.useMemo(()=>n?"e.g. e363c08d7e9ca4e66e723a53f38a21f6a54c1b83":Array(36).fill("*").join(""),[n]);return(0,t.jsx)(g.l0,{...W,children:(0,t.jsxs)("div",{className:(0,f.cn)("grid gap-2",r),...q,children:[(0,t.jsxs)("form",{className:"grid gap-4",onSubmit:W.handleSubmit(ee),children:[(0,t.jsx)(k.D,{children:"Basic information"}),(0,t.jsx)(g.Wi,{control:W.control,name:"provider",render:e=>{let{field:{onChange:r,...s}}=e;return(0,t.jsxs)(g.xJ,{children:[(0,t.jsx)(g.lX,{children:"Provider"}),(0,t.jsx)(g.NI,{children:(0,t.jsxs)(C.E,{className:"flex gap-8",orientation:"horizontal",onValueChange:r,...s,children:[(0,t.jsxs)("div",{className:"flex items-center",children:[(0,t.jsx)(C.m,{value:m.O4.Github,id:"r_github",disabled:!n}),(0,t.jsxs)(y._,{className:"flex cursor-pointer items-center gap-2 pl-2",htmlFor:"r_github",children:[(0,t.jsx)(b.IconGitHub,{className:"h-5 w-5"}),"GitHub"]})]}),(0,t.jsxs)("div",{className:"flex items-center",children:[(0,t.jsx)(C.m,{value:m.O4.Google,id:"r_google",disabled:!n}),(0,t.jsxs)(y._,{className:"flex cursor-pointer items-center gap-2 pl-2",htmlFor:"r_google",children:[(0,t.jsx)(b.IconGoogle,{className:"h-5 w-5"}),"Google"]})]}),(0,t.jsxs)("div",{className:"flex items-center",children:[(0,t.jsx)(C.m,{value:m.O4.Gitlab,id:"r_gitlab",disabled:!n}),(0,t.jsxs)(y._,{className:"flex cursor-pointer items-center gap-2 pl-2",htmlFor:"r_gitlab",children:[(0,t.jsx)(b.IconGitLab,{className:"h-5 w-5"}),"GitLab"]})]})]})}),(0,t.jsx)(g.zG,{})]})}}),er&&(0,t.jsx)(g.xJ,{className:"mt-4",children:(0,t.jsxs)("div",{className:"flex flex-col gap-2 overflow-hidden rounded-lg border px-3 py-2",children:[(0,t.jsx)("div",{className:"text-sm text-muted-foreground",children:"Create your OAuth2 application with the following information"}),(0,t.jsxs)("div",{className:"flex flex-col justify-between sm:flex-row sm:items-center",children:[(0,t.jsx)("div",{className:"text-sm font-medium",children:"Authorization callback URL"}),(0,t.jsxs)("span",{className:"flex items-center text-sm",children:[(0,t.jsx)("span",{className:"truncate",children:er.oauthCallbackUrl}),(0,t.jsx)(I.q,{className:"shrink-0",type:"button",value:er.oauthCallbackUrl})]})]})]})}),(0,t.jsxs)("div",{className:"mt-4",children:[(0,t.jsx)(k.D,{children:"OAuth provider information"}),(0,t.jsx)(g.pf,{children:"The information is provided by your identity provider."})]}),(0,t.jsx)(g.Wi,{control:W.control,name:"clientId",render:e=>{let{field:r}=e;return(0,t.jsxs)(g.xJ,{children:[(0,t.jsx)(g.lX,{required:!0,children:"Client ID"}),(0,t.jsx)(g.NI,{children:(0,t.jsx)(N.I,{placeholder:"e.g. ae1542c44b154c10c859",autoCapitalize:"none",autoComplete:"off",autoCorrect:"off",...r})}),(0,t.jsx)(g.zG,{})]})}}),(0,t.jsx)(g.Wi,{control:W.control,name:"clientSecret",render:e=>{let{field:r}=e;return(0,t.jsxs)(g.xJ,{children:[(0,t.jsx)(g.lX,{required:n,children:"Client Secret"}),(0,t.jsx)(g.NI,{children:(0,t.jsx)(N.I,{className:(0,f.cn)({"placeholder:translate-y-[10%] !placeholder-foreground":!n}),placeholder:en,autoCapitalize:"none",autoComplete:"off",autoCorrect:"off",type:"password",...r})}),(0,t.jsx)(g.zG,{})]})}}),(0,t.jsx)(w.Z,{className:"my-2"}),(0,t.jsxs)("div",{className:"flex justify-end gap-4",children:[(0,t.jsx)(v.z,{type:"button",variant:"ghost",onClick:Y,children:"Back"}),!n&&(0,t.jsxs)(j.aR,{open:U,onOpenChange:V,children:[(0,t.jsx)(j.vW,{asChild:!0,children:(0,t.jsx)(v.z,{variant:"hover-destructive",children:"Delete"})}),(0,t.jsxs)(j._T,{children:[(0,t.jsxs)(j.fY,{children:[(0,t.jsx)(j.f$,{children:"Are you absolutely sure?"}),(0,t.jsx)(j.yT,{children:"This action cannot be undone. It will permanently delete the current credential."})]}),(0,t.jsxs)(j.xo,{children:[(0,t.jsx)(j.le,{children:"Cancel"}),(0,t.jsxs)(j.OL,{className:(0,v.d)({variant:"destructive"}),onClick:e=>{e.preventDefault(),E(!0),K({provider:$}).then(e=>{var r,n;(null==e?void 0:null===(r=e.data)||void 0===r?void 0:r.deleteOauthCredential)?Y():(E(!1),(null==e?void 0:e.error)&&d.A.error(null==e?void 0:null===(n=e.error)||void 0===n?void 0:n.message))})},children:[B&&(0,t.jsx)(b.IconSpinner,{className:"mr-2 h-4 w-4 animate-spin"}),"Yes, delete it"]})]})]})]}),(0,t.jsx)(z.M,{licenses:[m.oj.Enterprise],children:e=>{let{hasValidLicense:r}=e;return(0,t.jsxs)(v.z,{type:"submit",disabled:!r||F||!n&&!M,children:[F&&(0,t.jsx)(b.IconSpinner,{className:"mr-2 h-4 w-4 animate-spin"}),n?"Create":"Update"]})}})]})]}),(0,t.jsx)(g.zG,{className:"text-center"})]})})}},54304:function(e,r,n){"use strict";n.r(r),n.d(r,{NewPage:function(){return p}});var t=n(36164),s=n(3546),l=n(11978),i=n(1853),a=n(40055),o=n(18500),d=n(70410),c=n(6230),u=n(90379),x=n(20255),m=n(7846),h=n(31988);function p(){let[e,r]=(0,s.useState)("oauth"),n=(0,l.useRouter)(),[{data:p,fetching:f}]=(0,a.aM)({query:d.Ry,variables:{provider:o.O4.Github}}),[{data:j,fetching:v}]=(0,a.aM)({query:d.Ry,variables:{provider:o.O4.Google}}),[{data:g,fetching:b}]=(0,a.aM)({query:d.Ry,variables:{provider:o.O4.Gitlab}}),[{data:N,fetching:y}]=(0,a.aM)({query:d.wz}),C=!!(null==N?void 0:N.ldapCredential),w=(0,i.Z)([(null==p?void 0:p.oauthCredential)&&o.O4.Github,(null==j?void 0:j.oauthCredential)&&o.O4.Google,(null==g?void 0:g.oauthCredential)&&o.O4.Gitlab]),I=()=>{n.replace("/settings/sso")};return(0,t.jsx)(c.Z,{loading:f||v||b||y,fallback:(0,t.jsx)(u.cg,{}),children:(0,t.jsxs)("div",{children:[(0,t.jsx)(h.w,{value:e,onChange:r}),"oauth"===e?(0,t.jsx)(m.ZP,{isNew:!0,defaultProvider:o.O4.Github,existedProviders:w,onSuccess:I,className:"mt-6"}):(0,t.jsx)(x.u,{isNew:!0,defaultValues:{skipTlsVerify:!1},onSuccess:I,existed:C})]})})}},48537:function(e,r,n){"use strict";n.d(r,{q:function(){return a}});var t=n(36164);n(3546);var s=n(28312),l=n(31458),i=n(81565);function a(e){let{className:r,value:n,onCopyContent:a,text:o,...d}=e,{isCopied:c,copyToClipboard:u}=(0,s.m)({timeout:2e3,onCopyContent:a});return n?(0,t.jsxs)(l.z,{variant:"ghost",size:o?"default":"icon",className:r,onClick:()=>{c||u(n)},...d,children:[c?(0,t.jsx)(i.IconCheck,{className:"text-green-600"}):(0,t.jsx)(i.IconCopy,{}),o&&(0,t.jsx)("span",{children:o}),!o&&(0,t.jsx)("span",{className:"sr-only",children:"Copy"})]}):null}},95052:function(e,r,n){"use strict";n.d(r,{X:function(){return o}});var t=n(36164),s=n(3546),l=n(30317),i=n(57288),a=n(81565);let o=s.forwardRef((e,r)=>{let{className:n,...s}=e;return(0,t.jsx)(l.fC,{ref:r,className:(0,i.cn)("peer h-4 w-4 shrink-0 rounded-sm border border-primary ring-offset-background focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:cursor-not-allowed disabled:opacity-50 data-[state=checked]:bg-primary data-[state=checked]:text-primary-foreground",n),...s,children:(0,t.jsx)(l.z$,{className:(0,i.cn)("flex items-center justify-center text-current"),children:(0,t.jsx)(a.IconCheck,{className:"h-4 w-4"})})})});o.displayName=l.fC.displayName},54594:function(e,r,n){"use strict";n.d(r,{Bw:function(){return x},DI:function(){return d},Ph:function(){return o},Ql:function(){return h},U$:function(){return p},i4:function(){return u},ki:function(){return c}});var t=n(36164),s=n(3546),l=n(31889),i=n(57288),a=n(81565);let o=l.fC,d=l.ZA,c=l.B4,u=s.forwardRef((e,r)=>{let{className:n,children:s,...o}=e;return(0,t.jsxs)(l.xz,{ref:r,className:(0,i.cn)("flex h-9 w-full items-center justify-between rounded-md border border-input bg-transparent px-3 py-2 text-sm shadow ring-offset-background placeholder:text-muted-foreground focus:outline-none focus:ring-2 focus:ring-ring focus:ring-offset-2 disabled:cursor-not-allowed disabled:opacity-50",n),...o,children:[s,(0,t.jsx)(l.JO,{asChild:!0,children:(0,t.jsx)(a.IconChevronUpDown,{className:"opacity-50"})})]})});u.displayName=l.xz.displayName;let x=s.forwardRef((e,r)=>{let{className:n,children:s,position:a="popper",...o}=e;return(0,t.jsx)(l.h_,{children:(0,t.jsx)(l.VY,{ref:r,className:(0,i.cn)("relative z-50 min-w-[8rem] overflow-hidden rounded-md border bg-popover text-popover-foreground shadow-md animate-in fade-in-80","popper"===a&&"translate-y-1",n),position:a,...o,children:(0,t.jsx)(l.l_,{className:(0,i.cn)("p-1","popper"===a&&"h-[var(--radix-select-trigger-height)] w-full min-w-[var(--radix-select-trigger-width)]"),children:s})})})});x.displayName=l.VY.displayName;let m=s.forwardRef((e,r)=>{let{className:n,...s}=e;return(0,t.jsx)(l.__,{ref:r,className:(0,i.cn)("py-1.5 pl-8 pr-2 text-sm font-semibold",n),...s})});m.displayName=l.__.displayName;let h=s.forwardRef((e,r)=>{let{className:n,children:s,isPlaceHolder:o,...d}=e;return(0,t.jsxs)(l.ck,{ref:r,className:(0,i.cn)("relative flex w-full cursor-default select-none items-center rounded-sm py-1.5 pl-8 pr-2 text-sm outline-none focus:bg-accent focus:text-accent-foreground data-[disabled]:pointer-events-none data-[disabled]:opacity-50",n),...d,children:[!o&&(0,t.jsx)("span",{className:"absolute left-2 flex h-3.5 w-3.5 items-center justify-center",children:(0,t.jsx)(l.wU,{children:(0,t.jsx)(a.IconCheck,{className:"h-4 w-4"})})}),(0,t.jsx)(l.eT,{children:s})]})});h.displayName=l.ck.displayName;let p=s.forwardRef((e,r)=>{let{className:n,...s}=e;return(0,t.jsx)(l.Z0,{ref:r,className:(0,i.cn)("-mx-1 my-1 h-px bg-muted",n),...s})});p.displayName=l.Z0.displayName},28312:function(e,r,n){"use strict";n.d(r,{m:function(){return a}});var t=n(3546),s=n(61200),l=n.n(s),i=n(2578);function a(e){let{timeout:r=2e3,onError:n,onCopyContent:s}=e,[a,o]=t.useState(!1),d=()=>{o(!0),setTimeout(()=>{o(!1)},r)},c=e=>{if("function"==typeof n){null==n||n(e);return}i.A.error("Failed to copy.")};return{isCopied:a,copyToClipboard:e=>{var r;if(e){if(s){s(e),d();return}if(null===(r=navigator.clipboard)||void 0===r?void 0:r.writeText)navigator.clipboard.writeText(e).then(d).catch(c);else{let r=l()(e);r?d():c()}}}}}}},function(e){e.O(0,[7565,8415,7430,8516,1652,340,4007,2546,1283,3449,2578,8511,240,2287,8961,1889,3707,3301,7488,7288,1565,3240,4656,8040,3375,5289,1744],function(){return e(e.s=10814)}),_N_E=e.O()}]);