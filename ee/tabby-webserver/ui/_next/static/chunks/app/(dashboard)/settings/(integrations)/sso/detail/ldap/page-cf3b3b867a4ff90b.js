(self.webpackChunk_N_E=self.webpackChunk_N_E||[]).push([[1704],{48850:function(e,r,t){Promise.resolve().then(t.bind(t,61367))},20255:function(e,r,t){"use strict";t.d(r,{u:function(){return L}});var n=t(36164),s=t(3546),a=t(11978),i=t(84381),l=t(94909),o=t(5493),c=t(2578),d=t(40055),u=t(23782),f=t(43240),p=t(18500),m=t(11634),x=t(70410),h=t(57288),j=t(73460),v=t(31458),b=t(95052),y=t(98150),w=t(81565),g=t(82394),C=t(54594),N=t(11208),Z=t(94770),k=t(10221);let _=(0,f.BX)("\n  mutation testLdapConnection($input: UpdateLdapCredentialInput!) {\n    testLdapConnection(input: $input)\n  }\n"),I=(0,f.BX)("\n  mutation updateLdapCredential($input: UpdateLdapCredentialInput!) {\n    updateLdapCredential(input: $input)\n  }\n"),z=(0,f.BX)("\n  mutation deleteLdapCredential {\n    deleteLdapCredential\n  }\n"),D=u.Ry({host:u.Z_(),port:u.oQ.number({required_error:"Required",invalid_type_error:"Invalid port"}),bindDn:u.Z_(),bindPassword:u.Z_().optional(),baseDn:u.Z_(),userFilter:u.Z_(),encryption:u.jb(p.y),skipTlsVerify:u.O7(),emailAttribute:u.Z_(),nameAttribute:u.Z_().optional()}),E="LDAP provider already exists and cannot be created again.";function L(e){let{className:r,isNew:t,defaultValues:u,onSuccess:f,existed:L,...S}=e,P=(0,a.useRouter)(),O=(0,d.m8)(),R=s.useRef(null),[A,T]=s.useState(!1),X=s.useMemo(()=>({...u||{}}),[]),[q,V]=s.useState(!1),[W,M]=s.useState(!1),G=(0,o.cI)({resolver:(0,i.F)(D),defaultValues:X}),J=!(0,l.Z)(G.formState.dirtyFields),B=G.formState.isValid,{isSubmitting:U}=G.formState,$=()=>{P.replace("/settings/sso")},F=(0,m.Db)(I,{onCompleted(e){(null==e?void 0:e.updateLdapCredential)&&(null==f||f(G.getValues()))},form:G}),Q=(0,m.Db)(_,{onError(e){c.A.error(e.message)},onCompleted(e){(null==e?void 0:e.testLdapConnection)?c.A.success("LDAP connection test success.",{className:"mb-10"}):c.A.error("LDAP connection test failed.")}}),Y=(0,m.Db)(z),H=async e=>{if(t){let e=await O.query(x.wz,{}).then(e=>{var r;return!!(null==e?void 0:null===(r=e.data)||void 0===r?void 0:r.ldapCredential)});if(e){G.setError("root",{message:E});return}}return F({input:e})},K=s.useMemo(()=>{if(!t)return Array(36).fill("*").join("")},[t]);return(0,n.jsx)(y.l0,{...G,children:(0,n.jsxs)("div",{className:(0,h.cn)("grid gap-2",r),...S,children:[L&&(0,n.jsx)("div",{className:"mt-2 text-sm font-medium text-destructive",children:E}),(0,n.jsxs)("form",{className:"mt-6 grid gap-4",onSubmit:G.handleSubmit(H),ref:R,children:[(0,n.jsxs)("div",{children:[(0,n.jsx)(k.D,{children:"LDAP provider information"}),(0,n.jsx)(y.pf,{children:"The information is provided by your identity provider."})]}),(0,n.jsxs)("div",{className:"flex flex-col gap-6 lg:flex-row",children:[(0,n.jsx)(y.Wi,{control:G.control,name:"host",render:e=>{let{field:r}=e;return(0,n.jsxs)(y.xJ,{children:[(0,n.jsx)(y.lX,{required:!0,children:"Host"}),(0,n.jsx)(y.NI,{children:(0,n.jsx)(g.I,{placeholder:"e.g. ldap.example.com",autoCapitalize:"none",autoComplete:"off",autoCorrect:"off",className:"w-80 min-w-max",...r})}),(0,n.jsx)(y.zG,{})]})}}),(0,n.jsx)(y.Wi,{control:G.control,name:"port",render:e=>{let{field:r}=e;return(0,n.jsxs)(y.xJ,{children:[(0,n.jsx)(y.lX,{required:!0,children:"Port"}),(0,n.jsx)(y.NI,{children:(0,n.jsx)(g.I,{placeholder:"e.g. 3890",autoCapitalize:"none",autoComplete:"off",autoCorrect:"off",className:"w-80 min-w-max",...r})}),(0,n.jsx)(y.zG,{})]})}})]}),(0,n.jsxs)("div",{className:"flex flex-col gap-6 lg:flex-row",children:[(0,n.jsx)(y.Wi,{control:G.control,name:"bindDn",render:e=>{let{field:r}=e;return(0,n.jsxs)(y.xJ,{children:[(0,n.jsx)(y.lX,{required:!0,children:"Bind DN"}),(0,n.jsx)(y.NI,{children:(0,n.jsx)(g.I,{placeholder:"e.g. uid=system,ou=Users,dc=example,dc=com",autoCapitalize:"none",autoComplete:"off",autoCorrect:"off",className:"w-80 min-w-max",...r})}),(0,n.jsx)(y.zG,{})]})}}),(0,n.jsx)(y.Wi,{control:G.control,name:"bindPassword",render:e=>{let{field:r}=e;return(0,n.jsxs)(y.xJ,{children:[(0,n.jsx)(y.lX,{required:t,children:"Bind Password"}),(0,n.jsx)(y.NI,{children:(0,n.jsx)(g.I,{className:(0,h.cn)("w-80 min-w-max",{"placeholder:translate-y-[10%] !placeholder-foreground/50":!t}),placeholder:K,autoCapitalize:"none",autoComplete:"off",autoCorrect:"off",type:"password",...r})}),(0,n.jsx)(y.zG,{})]})}})]}),(0,n.jsx)(y.Wi,{control:G.control,name:"baseDn",render:e=>{let{field:r}=e;return(0,n.jsxs)(y.xJ,{children:[(0,n.jsx)(y.lX,{required:!0,children:"Base DN"}),(0,n.jsx)(y.NI,{children:(0,n.jsx)(g.I,{placeholder:"e.g. ou=Users,dc=example,dc=com",autoCapitalize:"none",autoComplete:"off",autoCorrect:"off",className:"w-80 min-w-max",...r})}),(0,n.jsx)(y.zG,{})]})}}),(0,n.jsx)(y.Wi,{control:G.control,name:"userFilter",render:e=>{let{field:r}=e;return(0,n.jsxs)(y.xJ,{children:[(0,n.jsx)(y.lX,{required:!0,children:"User Filter"}),(0,n.jsx)(y.NI,{children:(0,n.jsx)(g.I,{placeholder:"e.g. (uid=%s)",autoCapitalize:"none",autoComplete:"off",autoCorrect:"off",className:"w-80 min-w-max",...r})}),(0,n.jsx)(y.zG,{})]})}}),(0,n.jsx)(y.Wi,{control:G.control,name:"encryption",render:e=>{let{field:r}=e;return(0,n.jsxs)(y.xJ,{children:[(0,n.jsx)(y.lX,{required:!0,children:"Encryption"}),(0,n.jsxs)(C.Ph,{onValueChange:r.onChange,defaultValue:r.value,name:r.name,children:[(0,n.jsx)(y.NI,{children:(0,n.jsx)(C.i4,{className:"w-80 min-w-max",children:(0,n.jsx)(C.ki,{placeholder:"Select an encryption"})})}),(0,n.jsxs)(C.Bw,{children:[(0,n.jsx)(C.Ql,{value:p.y.None,children:"NONE"}),(0,n.jsx)(C.Ql,{value:p.y.StartTls,children:"STARTTLS"}),(0,n.jsx)(C.Ql,{value:p.y.Ldaps,children:"LDAPS"})]})]}),(0,n.jsx)(y.zG,{})]})}}),(0,n.jsx)(y.Wi,{control:G.control,name:"skipTlsVerify",render:e=>{let{field:r}=e;return(0,n.jsxs)(y.xJ,{children:[(0,n.jsx)(y.lX,{children:"Connection security"}),(0,n.jsxs)("div",{className:"flex items-center gap-1",children:[(0,n.jsx)(y.NI,{children:(0,n.jsx)(b.X,{checked:r.value,onCheckedChange:r.onChange})}),(0,n.jsx)(y.lX,{className:"cursor-pointer",children:"Skip TLS Verify"})]}),(0,n.jsx)(y.zG,{})]})}}),(0,n.jsxs)("div",{className:"mt-4",children:[(0,n.jsx)(k.D,{children:"User information mapping"}),(0,n.jsx)(y.pf,{children:"Maps the field names from user info API to the Tabby user."})]}),(0,n.jsx)(y.Wi,{control:G.control,name:"emailAttribute",render:e=>{let{field:r}=e;return(0,n.jsxs)(y.xJ,{children:[(0,n.jsx)(y.lX,{required:!0,children:"Email"}),(0,n.jsx)(y.NI,{children:(0,n.jsx)(g.I,{autoCapitalize:"none",autoComplete:"off",autoCorrect:"off",className:"w-80 min-w-max",placeholder:"e.g. email",...r})}),(0,n.jsx)(y.zG,{})]})}}),(0,n.jsx)(y.Wi,{control:G.control,name:"nameAttribute",render:e=>{let{field:r}=e;return(0,n.jsxs)(y.xJ,{children:[(0,n.jsx)(y.lX,{children:"Name"}),(0,n.jsx)(y.NI,{children:(0,n.jsx)(g.I,{autoCapitalize:"none",autoComplete:"off",autoCorrect:"off",className:"w-80 min-w-max",placeholder:"e.g. name",...r})}),(0,n.jsx)(y.zG,{})]})}}),(0,n.jsx)(N.Z,{className:"my-2"}),(0,n.jsxs)("div",{className:"flex flex-col gap-4 sm:flex-row sm:justify-between",children:[(0,n.jsxs)(v.z,{onClick:()=>{R.current&&G.trigger().then(e=>{if(e)return T(!0),Q({input:D.parse(G.getValues())}).finally(()=>{T(!1)})})},type:"button",variant:"outline",disabled:t&&!B||A,children:["Test Connection",A&&(0,n.jsx)(w.IconSpinner,{className:"mr-2 h-4 w-4 animate-spin"})]}),(0,n.jsxs)("div",{className:"flex items-center justify-end gap-4 sm:justify-start",children:[(0,n.jsx)(v.z,{type:"button",variant:"ghost",onClick:$,children:"Back"}),!t&&(0,n.jsxs)(j.aR,{open:q,onOpenChange:V,children:[(0,n.jsx)(j.vW,{asChild:!0,children:(0,n.jsx)(v.z,{variant:"hover-destructive",children:"Delete"})}),(0,n.jsxs)(j._T,{children:[(0,n.jsxs)(j.fY,{children:[(0,n.jsx)(j.f$,{children:"Are you absolutely sure?"}),(0,n.jsx)(j.yT,{children:"This action cannot be undone. It will permanently delete the current credential."})]}),(0,n.jsxs)(j.xo,{children:[(0,n.jsx)(j.le,{children:"Cancel"}),(0,n.jsxs)(j.OL,{className:(0,v.d)({variant:"destructive"}),onClick:e=>{e.preventDefault(),M(!0),Y().then(e=>{var r,t;(null==e?void 0:null===(r=e.data)||void 0===r?void 0:r.deleteLdapCredential)?$():(M(!1),(null==e?void 0:e.error)&&c.A.error(null==e?void 0:null===(t=e.error)||void 0===t?void 0:t.message))})},children:[W&&(0,n.jsx)(w.IconSpinner,{className:"mr-2 h-4 w-4 animate-spin"}),"Yes, delete it"]})]})]})]}),(0,n.jsx)(Z.M,{licenses:[p.oj.Enterprise],children:e=>{let{hasValidLicense:r}=e;return(0,n.jsxs)(v.z,{type:"submit",disabled:!r||U||!t&&!J,children:[U&&(0,n.jsx)(w.IconSpinner,{className:"mr-2 h-4 w-4 animate-spin"}),t?"Create":"Update"]})}})]})]})]}),(0,n.jsx)(y.zG,{className:"text-center"})]})})}},61367:function(e,r,t){"use strict";t.r(r),t.d(r,{LdapCredentialDetail:function(){return m}});var n=t(36164),s=t(3546),a=t(11978),i=t(74630),l=t(25937),o=t(40055),c=t(70410),d=t(6230),u=t(90379),f=t(20255),p=t(31988);let m=()=>{let e=(0,a.useRouter)(),[{data:r,fetching:t}]=(0,o.aM)({query:c.wz}),m=null==r?void 0:r.ldapCredential,x=s.useMemo(()=>{if(m)return(0,l.Z)(m,e=>!(0,i.Z)(e))},[m]);return(0,n.jsx)("div",{children:(0,n.jsxs)(d.Z,{loading:t,fallback:(0,n.jsx)(u.cg,{className:"mt-2"}),children:[(0,n.jsx)(p.w,{value:"ldap",readonly:!0}),(0,n.jsx)(f.u,{defaultValues:x,onSuccess:()=>{e.push("/settings/sso")},className:"mt-6"})]})})}},95052:function(e,r,t){"use strict";t.d(r,{X:function(){return o}});var n=t(36164),s=t(3546),a=t(30317),i=t(57288),l=t(81565);let o=s.forwardRef((e,r)=>{let{className:t,...s}=e;return(0,n.jsx)(a.fC,{ref:r,className:(0,i.cn)("peer h-4 w-4 shrink-0 rounded-sm border border-primary ring-offset-background focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:cursor-not-allowed disabled:opacity-50 data-[state=checked]:bg-primary data-[state=checked]:text-primary-foreground",t),...s,children:(0,n.jsx)(a.z$,{className:(0,i.cn)("flex items-center justify-center text-current"),children:(0,n.jsx)(l.IconCheck,{className:"h-4 w-4"})})})});o.displayName=a.fC.displayName},54594:function(e,r,t){"use strict";t.d(r,{Bw:function(){return f},DI:function(){return c},Ph:function(){return o},Ql:function(){return m},U$:function(){return x},i4:function(){return u},ki:function(){return d}});var n=t(36164),s=t(3546),a=t(31889),i=t(57288),l=t(81565);let o=a.fC,c=a.ZA,d=a.B4,u=s.forwardRef((e,r)=>{let{className:t,children:s,...o}=e;return(0,n.jsxs)(a.xz,{ref:r,className:(0,i.cn)("flex h-9 w-full items-center justify-between rounded-md border border-input bg-transparent px-3 py-2 text-sm shadow ring-offset-background placeholder:text-muted-foreground focus:outline-none focus:ring-2 focus:ring-ring focus:ring-offset-2 disabled:cursor-not-allowed disabled:opacity-50",t),...o,children:[s,(0,n.jsx)(a.JO,{asChild:!0,children:(0,n.jsx)(l.IconChevronUpDown,{className:"opacity-50"})})]})});u.displayName=a.xz.displayName;let f=s.forwardRef((e,r)=>{let{className:t,children:s,position:l="popper",...o}=e;return(0,n.jsx)(a.h_,{children:(0,n.jsx)(a.VY,{ref:r,className:(0,i.cn)("relative z-50 min-w-[8rem] overflow-hidden rounded-md border bg-popover text-popover-foreground shadow-md animate-in fade-in-80","popper"===l&&"translate-y-1",t),position:l,...o,children:(0,n.jsx)(a.l_,{className:(0,i.cn)("p-1","popper"===l&&"h-[var(--radix-select-trigger-height)] w-full min-w-[var(--radix-select-trigger-width)]"),children:s})})})});f.displayName=a.VY.displayName;let p=s.forwardRef((e,r)=>{let{className:t,...s}=e;return(0,n.jsx)(a.__,{ref:r,className:(0,i.cn)("py-1.5 pl-8 pr-2 text-sm font-semibold",t),...s})});p.displayName=a.__.displayName;let m=s.forwardRef((e,r)=>{let{className:t,children:s,isPlaceHolder:o,...c}=e;return(0,n.jsxs)(a.ck,{ref:r,className:(0,i.cn)("relative flex w-full cursor-default select-none items-center rounded-sm py-1.5 pl-8 pr-2 text-sm outline-none focus:bg-accent focus:text-accent-foreground data-[disabled]:pointer-events-none data-[disabled]:opacity-50",t),...c,children:[!o&&(0,n.jsx)("span",{className:"absolute left-2 flex h-3.5 w-3.5 items-center justify-center",children:(0,n.jsx)(a.wU,{children:(0,n.jsx)(l.IconCheck,{className:"h-4 w-4"})})}),(0,n.jsx)(a.eT,{children:s})]})});m.displayName=a.ck.displayName;let x=s.forwardRef((e,r)=>{let{className:t,...s}=e;return(0,n.jsx)(a.Z0,{ref:r,className:(0,i.cn)("-mx-1 my-1 h-px bg-muted",t),...s})});x.displayName=a.Z0.displayName},54491:function(e,r,t){"use strict";function n(e,[r,t]){return Math.min(t,Math.max(r,e))}t.d(r,{u:function(){return n}})},30317:function(e,r,t){"use strict";t.d(r,{fC:function(){return C},z$:function(){return N}});var n=t(65122),s=t(3546),a=t(79869),i=t(47091),l=t(65727),o=t(27250),c=t(81544),d=t(96593),u=t(96497),f=t(72205);let p="Checkbox",[m,x]=(0,i.b)(p),[h,j]=m(p),v=(0,s.forwardRef)((e,r)=>{let{__scopeCheckbox:t,name:i,checked:c,defaultChecked:d,required:u,disabled:p,value:m="on",onCheckedChange:x,...j}=e,[v,b]=(0,s.useState)(null),C=(0,a.e)(r,e=>b(e)),N=(0,s.useRef)(!1),Z=!v||!!v.closest("form"),[k=!1,_]=(0,o.T)({prop:c,defaultProp:d,onChange:x}),I=(0,s.useRef)(k);return(0,s.useEffect)(()=>{let e=null==v?void 0:v.form;if(e){let r=()=>_(I.current);return e.addEventListener("reset",r),()=>e.removeEventListener("reset",r)}},[v,_]),(0,s.createElement)(h,{scope:t,state:k,disabled:p},(0,s.createElement)(f.WV.button,(0,n.Z)({type:"button",role:"checkbox","aria-checked":w(k)?"mixed":k,"aria-required":u,"data-state":g(k),"data-disabled":p?"":void 0,disabled:p,value:m},j,{ref:C,onKeyDown:(0,l.M)(e.onKeyDown,e=>{"Enter"===e.key&&e.preventDefault()}),onClick:(0,l.M)(e.onClick,e=>{_(e=>!!w(e)||!e),Z&&(N.current=e.isPropagationStopped(),N.current||e.stopPropagation())})})),Z&&(0,s.createElement)(y,{control:v,bubbles:!N.current,name:i,value:m,checked:k,required:u,disabled:p,style:{transform:"translateX(-100%)"}}))}),b=(0,s.forwardRef)((e,r)=>{let{__scopeCheckbox:t,forceMount:a,...i}=e,l=j("CheckboxIndicator",t);return(0,s.createElement)(u.z,{present:a||w(l.state)||!0===l.state},(0,s.createElement)(f.WV.span,(0,n.Z)({"data-state":g(l.state),"data-disabled":l.disabled?"":void 0},i,{ref:r,style:{pointerEvents:"none",...e.style}})))}),y=e=>{let{control:r,checked:t,bubbles:a=!0,...i}=e,l=(0,s.useRef)(null),o=(0,c.D)(t),u=(0,d.t)(r);return(0,s.useEffect)(()=>{let e=l.current,r=window.HTMLInputElement.prototype,n=Object.getOwnPropertyDescriptor(r,"checked"),s=n.set;if(o!==t&&s){let r=new Event("click",{bubbles:a});e.indeterminate=w(t),s.call(e,!w(t)&&t),e.dispatchEvent(r)}},[o,t,a]),(0,s.createElement)("input",(0,n.Z)({type:"checkbox","aria-hidden":!0,defaultChecked:!w(t)&&t},i,{tabIndex:-1,ref:l,style:{...e.style,...u,position:"absolute",pointerEvents:"none",opacity:0,margin:0}}))};function w(e){return"indeterminate"===e}function g(e){return w(e)?"indeterminate":e?"checked":"unchecked"}let C=v,N=b},99807:function(e,r,t){"use strict";t.d(r,{T:function(){return i},f:function(){return l}});var n=t(65122),s=t(3546),a=t(72205);let i=(0,s.forwardRef)((e,r)=>(0,s.createElement)(a.WV.span,(0,n.Z)({},e,{ref:r,style:{position:"absolute",border:0,width:1,height:1,padding:0,margin:-1,overflow:"hidden",clip:"rect(0, 0, 0, 0)",whiteSpace:"nowrap",wordWrap:"normal",...e.style}}))),l=i},26581:function(e,r,t){"use strict";var n=t(74913),s=t(77725),a=Object.prototype.hasOwnProperty;r.Z=function(e,r,t){var i=e[r];a.call(e,r)&&(0,s.Z)(i,t)&&(void 0!==t||r in e)||(0,n.Z)(e,r,t)}},74913:function(e,r,t){"use strict";var n=t(27015);r.Z=function(e,r,t){"__proto__"==r&&n.Z?(0,n.Z)(e,r,{configurable:!0,enumerable:!0,value:t,writable:!0}):e[r]=t}},94219:function(e,r,t){"use strict";t.d(r,{Z:function(){return d}});var n=t(30586),s=t(26581),a=t(81913),i=t(26329),l=t(84639),o=t(80143),c=function(e,r,t,n){if(!(0,l.Z)(e))return e;r=(0,a.Z)(r,e);for(var c=-1,d=r.length,u=d-1,f=e;null!=f&&++c<d;){var p=(0,o.Z)(r[c]),m=t;if("__proto__"===p||"constructor"===p||"prototype"===p)break;if(c!=u){var x=f[p];void 0===(m=n?n(x,p,f):void 0)&&(m=(0,l.Z)(x)?x:(0,i.Z)(r[c+1])?[]:{})}(0,s.Z)(f,p,m),f=f[p]}return e},d=function(e,r,t){for(var s=-1,i=r.length,l={};++s<i;){var o=r[s],d=(0,n.Z)(e,o);t(d,o)&&c(l,(0,a.Z)(o,e),d)}return l}},27015:function(e,r,t){"use strict";var n=t(47404),s=function(){try{var e=(0,n.Z)(Object,"defineProperty");return e({},"",{}),e}catch(e){}}();r.Z=s},9841:function(e,r,t){"use strict";var n=t(95973),s=t(9111),a=t(82149);r.Z=function(e){return(0,n.Z)(e,a.Z,s.Z)}},8621:function(e,r,t){"use strict";var n=(0,t(34659).Z)(Object.getPrototypeOf,Object);r.Z=n},9111:function(e,r,t){"use strict";var n=t(68085),s=t(8621),a=t(45270),i=t(25407),l=Object.getOwnPropertySymbols?function(e){for(var r=[];e;)(0,n.Z)(r,(0,a.Z)(e)),e=(0,s.Z)(e);return r}:i.Z;r.Z=l},82149:function(e,r,t){"use strict";t.d(r,{Z:function(){return d}});var n=t(30762),s=t(84639),a=t(36586),i=function(e){var r=[];if(null!=e)for(var t in Object(e))r.push(t);return r},l=Object.prototype.hasOwnProperty,o=function(e){if(!(0,s.Z)(e))return i(e);var r=(0,a.Z)(e),t=[];for(var n in e)"constructor"==n&&(r||!l.call(e,n))||t.push(n);return t},c=t(20568),d=function(e){return(0,c.Z)(e)?(0,n.Z)(e,!0):o(e)}},25937:function(e,r,t){"use strict";var n=t(64143),s=t(51722),a=t(94219),i=t(9841);r.Z=function(e,r){if(null==e)return{};var t=(0,n.Z)((0,i.Z)(e),function(e){return[e]});return r=(0,s.Z)(r),(0,a.Z)(e,t,function(e,t){return r(e,t[0])})}}},function(e){e.O(0,[7565,8415,7430,8516,1652,340,4007,2546,1283,3449,2578,8511,240,2287,7070,8961,1889,3707,3301,7288,1565,3240,4656,8040,3375,5289,1744],function(){return e(e.s=48850)}),_N_E=e.O()}]);