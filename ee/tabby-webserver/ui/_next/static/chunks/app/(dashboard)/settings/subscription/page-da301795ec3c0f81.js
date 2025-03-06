(self.webpackChunk_N_E=self.webpackChunk_N_E||[]).push([[4303],{68310:function(e,t,r){Promise.resolve().then(r.bind(r,47166))},47166:function(e,t,r){"use strict";r.r(t),r.d(t,{default:function(){return P}});var n=r(36164),s=r(88542),a=r(99092),i=r.n(a),l=r(18500),c=r(29917),o=r(44645),u=r(63795),d=r(81565),f=r(3448),m=r(6230),x=r(73051),p=r(3546),h=r(84381),v=r(5493),j=r(2578),g=r(23782),b=r(43240),N=r(24449),y=r(11634),w=r(57288),Z=r(73460),C=r(31458),R=r(98150);let S=p.forwardRef((e,t)=>{let{className:r,...s}=e;return(0,n.jsx)("textarea",{className:(0,w.cn)("flex min-h-[80px] w-full rounded-md border border-input bg-transparent px-3 py-2 text-sm ring-offset-background placeholder:text-muted-foreground focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:cursor-not-allowed disabled:opacity-50",r),ref:t,...s})});S.displayName="Textarea";let E=g.Ry({license:g.Z_()}),k=(0,b.BX)("\n  mutation UploadLicense($license: String!) {\n    uploadLicense(license: $license)\n  }\n"),T=(0,b.BX)("\n  mutation ResetLicense {\n    resetLicense\n  }\n");function A(e){let{className:t,onSuccess:r,canReset:s,...a}=e,i=(0,v.cI)({resolver:(0,h.F)(E)}),l=i.watch("license"),[c,o]=p.useState(!1),[u,f]=p.useState(!1),[m,x]=p.useState(!1),g=(0,N.S)((e,t)=>{o(e),t&&(i.reset({license:""}),j.A.success("License is uploaded"),null==r||r())},500,{leading:!0}),b=(0,N.S)((e,t)=>{x(e),t&&(f(!1),null==r||r())},500,{leading:!0}),A=(0,y.Db)(k,{form:i}),O=(0,y.Db)(T);return(0,n.jsx)("div",{className:(0,w.cn)(t),...a,children:(0,n.jsx)(R.l0,{...i,children:(0,n.jsxs)("form",{className:"grid gap-6",onSubmit:i.handleSubmit(e=>(g.run(!0),A(e).then(e=>{var t;g.run(!1,null==e?void 0:null===(t=e.data)||void 0===t?void 0:t.uploadLicense)}))),children:[(0,n.jsx)(R.Wi,{control:i.control,name:"license",render:e=>{let{field:t}=e;return(0,n.jsxs)(R.xJ,{children:[(0,n.jsx)(R.NI,{children:(0,n.jsx)(S,{className:"min-h-[200px]",placeholder:"Paste your license here - write only",...t})}),(0,n.jsx)(R.zG,{})]})}}),(0,n.jsxs)("div",{className:"flex items-start justify-between gap-4",children:[(0,n.jsx)("div",{children:(0,n.jsx)(R.zG,{})}),(0,n.jsxs)("div",{className:"flex shrink-0 items-center gap-4",children:[(0,n.jsxs)(Z.aR,{open:u,onOpenChange:e=>{m||f(e)},children:[s&&(0,n.jsx)(Z.vW,{asChild:!0,children:(0,n.jsx)(C.z,{type:"button",variant:"hover-destructive",children:"Reset"})}),(0,n.jsxs)(Z._T,{children:[(0,n.jsxs)(Z.fY,{children:[(0,n.jsx)(Z.f$,{children:"Are you absolutely sure?"}),(0,n.jsx)(Z.yT,{children:"This action cannot be undone. It will reset the current license."})]}),(0,n.jsxs)(Z.xo,{children:[(0,n.jsx)(Z.le,{children:"Cancel"}),(0,n.jsxs)(Z.OL,{className:(0,C.d)({variant:"destructive"}),onClick:e=>{e.preventDefault(),b.run(!0),O().then(e=>{var t,r;let n=null==e?void 0:null===(t=e.data)||void 0===t?void 0:t.resetLicense;b.run(!1,n),(null==e?void 0:e.error)&&j.A.error(null!==(r=e.error.message)&&void 0!==r?r:"reset failed")})},disabled:m,children:[m&&(0,n.jsx)(d.IconSpinner,{className:"mr-2 h-4 w-4 animate-spin"}),"Yes, reset it"]})]})]})]}),(0,n.jsxs)(C.z,{type:"submit",disabled:c||!l,children:[c&&(0,n.jsx)(d.IconSpinner,{className:"mr-2 h-4 w-4 animate-spin"}),"Upload License"]})]})]})]})})})}var O=r(99047),I=r(29);let L=()=>(0,n.jsxs)(O.iA,{className:"border text-center",children:[(0,n.jsx)(O.xD,{children:(0,n.jsxs)(O.SC,{children:[(0,n.jsx)(O.ss,{className:"w-[40%]"}),_.map((e,t)=>{let{name:r,pricing:s,limit:a}=e;return(0,n.jsxs)(O.ss,{className:"w-[20%] text-center",children:[(0,n.jsx)("h1",{className:"py-4 text-2xl font-bold",children:r}),(0,n.jsx)("p",{className:"text-center font-semibold",children:s}),(0,n.jsx)("p",{className:"pb-2 pt-1",children:a})]},t)})]})}),(0,n.jsx)(O.RM,{children:F.map((e,t)=>{let{name:r,features:s}=e;return(0,n.jsx)(D,{name:r,features:s},t)})})]}),D=e=>{let{name:t,features:r}=e;return(0,n.jsxs)(n.Fragment,{children:[(0,n.jsx)(O.SC,{children:(0,n.jsx)(O.pj,{colSpan:4,className:"bg-accent text-left text-accent-foreground",children:t})}),r.map((e,t)=>{let{name:r,community:s,team:a,enterprise:i}=e;return(0,n.jsxs)(O.SC,{children:[(0,n.jsx)(O.pj,{className:"text-left",children:r}),(0,n.jsx)(O.pj,{className:"font-semibold",children:s}),(0,n.jsx)(O.pj,{className:"font-semibold",children:a}),(0,n.jsx)(O.pj,{className:"font-semibold text-primary",children:i})]},t)})]})},_=[{name:"Community",pricing:"$0 per user/month",limit:"Up to 5 users"},{name:"Team",pricing:"$19 per user/month",limit:"Up to 50 users"},{name:"Enterprise",pricing:"Contact Us",limit:"Customized, billed annually"}],U=e=>{let{children:t}=e;return(0,n.jsx)(I.pn,{children:(0,n.jsxs)(I.u,{children:[(0,n.jsx)(I.aJ,{children:(0,n.jsx)(d.IconInfoCircled,{})}),(0,n.jsx)(I._v,{children:(0,n.jsx)("p",{className:"max-w-[320px]",children:t})})]})})},z=(0,n.jsx)(d.IconCheck,{className:"mx-auto"}),F=[{name:"Features",features:[{name:"User count",community:"Up to 5",team:"Up to 50",enterprise:"Unlimited"},{name:"Secure Access",community:z,team:z,enterprise:z},{name:"Answer Engine",community:z,team:z,enterprise:z},{name:"Code Browser",community:z,team:z,enterprise:z},{name:(0,n.jsx)(e=>{let{name:t,children:r}=e;return(0,n.jsxs)("span",{className:"flex gap-1",children:[t,(0,n.jsx)(U,{children:r})]})},{name:"Context Providers",children:"Tabby can retrieve various contexts to enhance responses for code completion and answering questions. Context providers offer the ability to retrieve context from various sources, such as source code repositories and issue trackers."}),community:z,team:z,enterprise:z},{name:"Usage Reports and Analytics",community:z,team:z,enterprise:z},{name:"Enforce IDE / Extensions telemetry policy",community:"–",team:"–",enterprise:z},{name:"Authentication Domain",community:"–",team:"–",enterprise:z},{name:"Single Sign-On (SSO)",community:"–",team:"–",enterprise:z}]},{name:"Bespoke",features:[{name:"Support",community:"Community",team:"Email",enterprise:"Dedicated Slack channel"},{name:"Roadmap prioritization",community:"–",team:"–",enterprise:z}]}];function P(){let{updateUrlComponents:e}=(0,o.Z)(),[{data:t,fetching:r},s]=(0,c.jp)(),a=null==t?void 0:t.license,i=!!(null==a?void 0:a.type)&&a.type!==l.oj.Community;return(0,n.jsxs)(n.Fragment,{children:[(0,n.jsx)(x.b,{className:"mb-8",externalLink:"https://links.tabbyml.com/schedule-a-demo",externalLinkText:"\uD83D\uDCC6 Book a 30-minute product demo",children:"You can upload your Tabby license to unlock team/enterprise features."}),(0,n.jsxs)("div",{className:"flex flex-col gap-8",children:[(0,n.jsx)(m.Z,{loading:r,fallback:(0,n.jsxs)("div",{className:"grid grid-cols-3",children:[(0,n.jsx)(f.O,{className:"h-16 w-[80%]"}),(0,n.jsx)(f.O,{className:"h-16 w-[80%]"}),(0,n.jsx)(f.O,{className:"h-16 w-[80%]"})]}),children:a&&(0,n.jsx)(Y,{license:a})}),(0,n.jsx)(A,{onSuccess:()=>{e({searchParams:{del:["licenseExpired","seatsExceeded"]}}),s()},canReset:i}),(0,n.jsx)(L,{})]})]})}function Y(e){var t;let{license:r}=e,{isExpired:a,isSeatsExceeded:l}=(0,c.Cz)(),o=r.expiresAt?i()(r.expiresAt).format("MM/DD/YYYY"):"–",f="".concat(r.seatsUsed," / ").concat(r.seats);return(0,n.jsxs)("div",{className:"grid font-bold lg:grid-cols-3",children:[(0,n.jsxs)("div",{children:[(0,n.jsx)("div",{className:"mb-1 text-muted-foreground",children:"Expires at"}),(0,n.jsxs)("div",{className:"flex items-center gap-2 text-3xl",children:[o,a&&(0,n.jsxs)(u.C,{variant:"destructive",className:"flex items-center gap-1",children:[(0,n.jsx)(d.IconAlertTriangle,{className:"h-3 w-3"}),"Expired"]})]})]}),(0,n.jsxs)("div",{children:[(0,n.jsx)("div",{className:"mb-1 text-muted-foreground",children:"Assigned / Total Seats"}),(0,n.jsxs)("div",{className:"flex items-center gap-2 text-3xl",children:[f,l&&(0,n.jsxs)(u.C,{variant:"destructive",className:"flex items-center gap-1",children:[(0,n.jsx)(d.IconAlertTriangle,{className:"h-3 w-3"}),"Seats exceeded"]})]})]}),(0,n.jsxs)("div",{children:[(0,n.jsx)("div",{className:"mb-1 text-muted-foreground",children:"Current plan"}),(0,n.jsx)("div",{className:"text-3xl text-primary",children:(0,s.Z)(null!==(t=null==r?void 0:r.type)&&void 0!==t?t:"Community")})]})]})}},6230:function(e,t,r){"use strict";var n=r(36164),s=r(3546),a=r(24449),i=r(90379);t.Z=e=>{let{triggerOnce:t=!0,loading:r,fallback:l,delay:c,children:o}=e,[u,d]=s.useState(!r),[f]=(0,a.n)(u,null!=c?c:200);return(s.useEffect(()=>{t?r||u||d(!0):d(!r)},[r]),f)?o:l||(0,n.jsx)(i.cg,{})}},90379:function(e,t,r){"use strict";r.d(t,{PF:function(){return c},cg:function(){return i},tB:function(){return l}});var n=r(36164),s=r(57288),a=r(3448);let i=e=>{let{className:t,...r}=e;return(0,n.jsxs)("div",{className:(0,s.cn)("space-y-3",t),...r,children:[(0,n.jsx)(a.O,{className:"h-4 w-full"}),(0,n.jsx)(a.O,{className:"h-4 w-full"}),(0,n.jsx)(a.O,{className:"h-4 w-full"}),(0,n.jsx)(a.O,{className:"h-4 w-full"})]})},l=e=>{let{className:t,...r}=e;return(0,n.jsx)(a.O,{className:(0,s.cn)("h-4 w-full",t),...r})},c=e=>{let{className:t,...r}=e;return(0,n.jsxs)("div",{className:(0,s.cn)("flex flex-col gap-3",t),...r,children:[(0,n.jsx)(a.O,{className:"h-4 w-[20%]"}),(0,n.jsx)(a.O,{className:"h-4 w-full"}),(0,n.jsx)(a.O,{className:"h-4 w-[20%]"}),(0,n.jsx)(a.O,{className:"h-4 w-full"})]})}},73051:function(e,t,r){"use strict";r.d(t,{b:function(){return c}});var n=r(36164);r(3546);var s=r(70652),a=r.n(s),i=r(57288),l=r(81565);let c=e=>{let{className:t,externalLink:r,externalLinkText:s="Learn more",children:c}=e;return(0,n.jsx)("div",{className:(0,i.cn)("mb-4 flex items-center gap-4",t),children:(0,n.jsxs)("div",{className:"flex-1 text-sm text-muted-foreground",children:[c,!!r&&(0,n.jsxs)(a(),{className:"ml-2 inline-flex cursor-pointer flex-row items-center text-primary hover:underline",href:r,target:"_blank",children:[s,(0,n.jsx)(l.IconExternalLink,{className:"ml-1"})]})]})})}},73460:function(e,t,r){"use strict";r.d(t,{OL:function(){return v},_T:function(){return f},aR:function(){return c},f$:function(){return p},fY:function(){return m},le:function(){return j},vW:function(){return o},xo:function(){return x},yT:function(){return h}});var n=r(36164),s=r(3546),a=r(28961),i=r(57288),l=r(31458);let c=a.fC,o=a.xz,u=e=>{let{className:t,children:r,...s}=e;return(0,n.jsx)(a.h_,{className:(0,i.cn)(t),...s,children:(0,n.jsx)("div",{className:"fixed inset-0 z-50 flex items-end justify-center sm:items-center",children:r})})};u.displayName=a.h_.displayName;let d=s.forwardRef((e,t)=>{let{className:r,children:s,...l}=e;return(0,n.jsx)(a.aV,{className:(0,i.cn)("fixed inset-0 z-50 bg-background/80 backdrop-blur-sm transition-opacity animate-in fade-in",r),...l,ref:t})});d.displayName=a.aV.displayName;let f=s.forwardRef((e,t)=>{let{className:r,...s}=e;return(0,n.jsxs)(u,{children:[(0,n.jsx)(d,{}),(0,n.jsx)(a.VY,{ref:t,className:(0,i.cn)("fixed z-50 grid w-full max-w-lg scale-100 gap-4 border bg-background p-6 opacity-100 shadow-lg animate-in fade-in-90 slide-in-from-bottom-10 sm:rounded-lg sm:zoom-in-90 sm:slide-in-from-bottom-0 md:w-full",r),...s})]})});f.displayName=a.VY.displayName;let m=e=>{let{className:t,...r}=e;return(0,n.jsx)("div",{className:(0,i.cn)("flex flex-col space-y-2 text-center sm:text-left",t),...r})};m.displayName="AlertDialogHeader";let x=e=>{let{className:t,...r}=e;return(0,n.jsx)("div",{className:(0,i.cn)("flex flex-col-reverse sm:flex-row sm:justify-end sm:space-x-2",t),...r})};x.displayName="AlertDialogFooter";let p=s.forwardRef((e,t)=>{let{className:r,...s}=e;return(0,n.jsx)(a.Dx,{ref:t,className:(0,i.cn)("text-lg font-semibold",r),...s})});p.displayName=a.Dx.displayName;let h=s.forwardRef((e,t)=>{let{className:r,...s}=e;return(0,n.jsx)(a.dk,{ref:t,className:(0,i.cn)("text-sm text-muted-foreground",r),...s})});h.displayName=a.dk.displayName;let v=s.forwardRef((e,t)=>{let{className:r,...s}=e;return(0,n.jsx)(a.aU,{ref:t,className:(0,i.cn)((0,l.d)(),r),...s})});v.displayName=a.aU.displayName;let j=s.forwardRef((e,t)=>{let{className:r,...s}=e;return(0,n.jsx)(a.$j,{ref:t,className:(0,i.cn)((0,l.d)({variant:"outline"}),"mt-2 sm:mt-0",r),...s})});j.displayName=a.$j.displayName},63795:function(e,t,r){"use strict";r.d(t,{C:function(){return l}});var n=r(36164);r(3546);var s=r(14375),a=r(57288);let i=(0,s.j)("inline-flex items-center rounded-full border px-2.5 py-0.5 text-xs font-semibold transition-colors focus:outline-none focus:ring-2 focus:ring-ring focus:ring-offset-2",{variants:{variant:{default:"border-transparent bg-primary text-primary-foreground hover:bg-primary/80",secondary:"border-transparent bg-secondary text-secondary-foreground hover:bg-secondary/80",destructive:"border-transparent bg-destructive text-destructive-foreground hover:bg-destructive/80",successful:"border-transparent bg-successful text-successful-foreground hover:bg-successful/80",outline:"text-foreground"}},defaultVariants:{variant:"default"}});function l(e){let{className:t,variant:r,...s}=e;return(0,n.jsx)("div",{className:(0,a.cn)(i({variant:r}),t),...s})}},98150:function(e,t,r){"use strict";r.d(t,{NI:function(){return h},Wi:function(){return d},l0:function(){return o},lX:function(){return p},pf:function(){return v},xJ:function(){return x},zG:function(){return j}});var n=r(36164),s=r(3546),a=r(74047),i=r(5493),l=r(57288),c=r(5266);let o=i.RV,u=s.createContext({}),d=e=>{let{...t}=e;return(0,n.jsx)(u.Provider,{value:{name:t.name},children:(0,n.jsx)(i.Qr,{...t})})},f=()=>{let e=s.useContext(u),t=s.useContext(m),{getFieldState:r,formState:n}=(0,i.Gc)(),a=e.name||"root",l=r(a,n);if(!n)throw Error("useFormField should be used within <Form>");let{id:c}=t;return{id:c,name:a,formItemId:"".concat(c,"-form-item"),formDescriptionId:"".concat(c,"-form-item-description"),formMessageId:"".concat(c,"-form-item-message"),...l}},m=s.createContext({}),x=s.forwardRef((e,t)=>{let{className:r,...a}=e,i=s.useId();return(0,n.jsx)(m.Provider,{value:{id:i},children:(0,n.jsx)("div",{ref:t,className:(0,l.cn)("space-y-2",r),...a})})});x.displayName="FormItem";let p=s.forwardRef((e,t)=>{let{className:r,required:s,...a}=e,{error:i,formItemId:o}=f();return(0,n.jsx)(c._,{ref:t,className:(0,l.cn)(i&&"text-destructive",s&&'after:ml-0.5 after:text-destructive after:content-["*"]',r),htmlFor:o,...a})});p.displayName="FormLabel";let h=s.forwardRef((e,t)=>{let{...r}=e,{error:s,formItemId:i,formDescriptionId:l,formMessageId:c}=f();return(0,n.jsx)(a.g7,{ref:t,id:i,"aria-describedby":s?"".concat(l," ").concat(c):"".concat(l),"aria-invalid":!!s,...r})});h.displayName="FormControl";let v=s.forwardRef((e,t)=>{let{className:r,...s}=e,{formDescriptionId:a}=f();return(0,n.jsx)("div",{ref:t,id:a,className:(0,l.cn)("text-sm text-muted-foreground",r),...s})});v.displayName="FormDescription";let j=s.forwardRef((e,t)=>{let{className:r,children:s,...a}=e,{error:i,formMessageId:c}=f(),o=i?String(null==i?void 0:i.message):s;return o?(0,n.jsx)("p",{ref:t,id:c,className:(0,l.cn)("text-sm font-medium text-destructive",r),...a,children:o}):null});j.displayName="FormMessage"},5266:function(e,t,r){"use strict";r.d(t,{_:function(){return o}});var n=r(36164),s=r(3546),a=r(90893),i=r(14375),l=r(57288);let c=(0,i.j)("text-sm font-medium leading-none peer-disabled:cursor-not-allowed peer-disabled:opacity-70"),o=s.forwardRef((e,t)=>{let{className:r,...s}=e;return(0,n.jsx)(a.f,{ref:t,className:(0,l.cn)(c(),r),...s})});o.displayName=a.f.displayName},3448:function(e,t,r){"use strict";r.d(t,{O:function(){return a}});var n=r(36164),s=r(57288);function a(e){let{className:t,...r}=e;return(0,n.jsx)("div",{className:(0,s.cn)("h-4 animate-pulse rounded-md bg-border",t),...r})}},99047:function(e,t,r){"use strict";r.d(t,{RM:function(){return c},SC:function(){return u},iA:function(){return i},pj:function(){return f},ss:function(){return d},xD:function(){return l}});var n=r(36164),s=r(3546),a=r(57288);let i=s.forwardRef((e,t)=>{let{className:r,...s}=e;return(0,n.jsx)("table",{ref:t,className:(0,a.cn)("w-full caption-bottom text-sm",r),...s})});i.displayName="Table";let l=s.forwardRef((e,t)=>{let{className:r,...s}=e;return(0,n.jsx)("thead",{ref:t,className:(0,a.cn)("[&_tr]:border-b",r),...s})});l.displayName="TableHeader";let c=s.forwardRef((e,t)=>{let{className:r,...s}=e;return(0,n.jsx)("tbody",{ref:t,className:(0,a.cn)("[&_tr:last-child]:border-0",r),...s})});c.displayName="TableBody";let o=s.forwardRef((e,t)=>{let{className:r,...s}=e;return(0,n.jsx)("tfoot",{ref:t,className:(0,a.cn)("border-t bg-muted/50 font-medium [&>tr]:last:border-b-0",r),...s})});o.displayName="TableFooter";let u=s.forwardRef((e,t)=>{let{className:r,...s}=e;return(0,n.jsx)("tr",{ref:t,className:(0,a.cn)("border-b transition-colors hover:bg-muted/50 data-[state=selected]:bg-muted",r),...s})});u.displayName="TableRow";let d=s.forwardRef((e,t)=>{let{className:r,...s}=e;return(0,n.jsx)("th",{ref:t,className:(0,a.cn)("h-12 px-2 text-left align-middle font-medium text-muted-foreground [&:has([role=checkbox])]:pr-0",r),...s})});d.displayName="TableHead";let f=s.forwardRef((e,t)=>{let{className:r,...s}=e;return(0,n.jsx)("td",{ref:t,className:(0,a.cn)("p-2 align-middle [&:has([role=checkbox])]:pr-0",r),...s})});f.displayName="TableCell";let m=s.forwardRef((e,t)=>{let{className:r,...s}=e;return(0,n.jsx)("caption",{ref:t,className:(0,a.cn)("mt-4 text-sm text-muted-foreground",r),...s})});m.displayName="TableCaption"},29:function(e,t,r){"use strict";r.d(t,{_v:function(){return u},aJ:function(){return o},pn:function(){return l},u:function(){return c}});var n=r(36164),s=r(3546),a=r(44421),i=r(57288);let l=a.zt,c=a.fC,o=a.xz;a.h_;let u=s.forwardRef((e,t)=>{let{className:r,sideOffset:s=4,...l}=e;return(0,n.jsx)(a.VY,{ref:t,sideOffset:s,className:(0,i.cn)("z-50 overflow-hidden rounded-md border bg-popover px-3 py-1.5 text-xs font-medium text-popover-foreground shadow-md animate-in fade-in-50 data-[side=bottom]:slide-in-from-top-1 data-[side=left]:slide-in-from-right-1 data-[side=right]:slide-in-from-left-1 data-[side=top]:slide-in-from-bottom-1",r),...l})});u.displayName=a.VY.displayName},24449:function(e,t,r){"use strict";r.d(t,{S:function(){return l},n:function(){return c}});var n=r(3546),s=r(45391),a=r(16784);let i=e=>{let t=(0,a.d)(e);n.useEffect(()=>()=>{t.current()},[])};function l(e,t,r){let l=(0,a.d)(e),c=n.useMemo(()=>(0,s.Z)(function(){for(var e=arguments.length,t=Array(e),r=0;r<e;r++)t[r]=arguments[r];return l.current(...t)},t,r),[]);return i(()=>{var e;null==r||null===(e=r.onUnmount)||void 0===e||e.call(r,c),c.cancel()}),{run:c,cancel:c.cancel,flush:c.flush}}function c(e,t,r){let[s,a]=n.useState(e),{run:i}=l(()=>{a(e)},t,r);return n.useEffect(()=>{i()},[e]),[s,a]}},16784:function(e,t,r){"use strict";r.d(t,{d:function(){return s}});var n=r(3546);function s(e){let t=n.useRef(e);return t.current=e,t}},29917:function(e,t,r){"use strict";r.d(t,{Cz:function(){return u},Gm:function(){return o},jp:function(){return c}});var n=r(11978),s=r(40055),a=r(43240),i=r(18500);let l=(0,a.BX)("\n  query GetLicenseInfo {\n    license {\n      type\n      status\n      seats\n      seatsUsed\n      issuedAt\n      expiresAt\n    }\n  }\n"),c=()=>(0,s.aM)({query:l}),o=()=>{let[{data:e}]=c();return null==e?void 0:e.license},u=e=>{var t;let[{data:r}]=c(),s=null==r?void 0:r.license,a=(0,n.useSearchParams)(),l=!!s&&(!(null==e?void 0:null===(t=e.licenses)||void 0===t?void 0:t.length)||e.licenses.includes(s.type)),o=(null==s?void 0:s.status)===i.rW.Ok,u=(null==s?void 0:s.status)===i.rW.Expired,d=(null==s?void 0:s.status)===(null===i.rW||void 0===i.rW?void 0:i.rW.SeatsExceeded),f="expired"===a.get("licenseError"),m="seatsExceed"===a.get("licenseError");return{hasLicense:!!s,isLicenseOK:o&&!(f||m),isExpired:u||f,isSeatsExceeded:d||m,hasSufficientLicense:l}}},44645:function(e,t,r){"use strict";r.d(t,{Z:function(){return a}});var n=r(3546),s=r(11978);function a(){let e=(0,s.usePathname)(),t=(0,s.useRouter)(),r=(0,s.useSearchParams)(),a=(0,n.useCallback)(e=>{let t=new URLSearchParams(r);e&&Object.entries(e).forEach(e=>{let[r,n]=e;return t.set(r,n)});let n=t.toString();return n.length>0?"?".concat(n):""},[r]),i=(0,n.useCallback)(n=>{let s=function(e,t,r){var n,s;let a=null===(n=r.searchParams)||void 0===n?void 0:n.set,i=null===(s=r.searchParams)||void 0===s?void 0:s.del,l=new URLSearchParams(t);a&&Object.entries(a).forEach(e=>{let[t,r]=e;return l.set(t,r)}),i&&(Array.isArray(i)?i.forEach(e=>l.delete(e)):l.delete(i));let c=l.toString(),o=e;return c.length>0&&(o+="?".concat(c)),r.hash&&(o+="#".concat(r.hash.replace(/^#/,""))),o}((null==n?void 0:n.pathname)||e,r,n);return n.replace?t.replace(s):t.push(s),s},[e,r]);return{pathname:e,router:t,searchParams:r,getQueryString:a,updateUrlComponents:i}}},70652:function(e,t,r){e.exports=r(54007)},64143:function(e,t){"use strict";t.Z=function(e,t){for(var r=-1,n=null==e?0:e.length,s=Array(n);++r<n;)s[r]=t(e[r],r,e);return s}},1282:function(e,t){"use strict";t.Z=function(e,t,r){var n=-1,s=e.length;t<0&&(t=-t>s?0:s+t),(r=r>s?s:r)<0&&(r+=s),s=t>r?0:r-t>>>0,t>>>=0;for(var a=Array(s);++n<s;)a[n]=e[n+t];return a}},4109:function(e,t,r){"use strict";var n=r(7600),s=r(64143),a=r(38813),i=r(55357),l=1/0,c=n.Z?n.Z.prototype:void 0,o=c?c.toString:void 0;t.Z=function e(t){if("string"==typeof t)return t;if((0,a.Z)(t))return(0,s.Z)(t,e)+"";if((0,i.Z)(t))return o?o.call(t):"";var r=t+"";return"0"==r&&1/t==-l?"-0":r}},18216:function(e,t,r){"use strict";var n=r(6670),s=/^\s+/;t.Z=function(e){return e?e.slice(0,(0,n.Z)(e)+1).replace(s,""):e}},77934:function(e,t,r){"use strict";var n=r(1282);t.Z=function(e,t,r){var s=e.length;return r=void 0===r?s:r,!t&&r>=s?e:(0,n.Z)(e,t,r)}},59883:function(e,t){"use strict";var r=RegExp("[\\u200d\ud800-\udfff\\u0300-\\u036f\\ufe20-\\ufe2f\\u20d0-\\u20ff\\ufe0e\\ufe0f]");t.Z=function(e){return r.test(e)}},14955:function(e,t,r){"use strict";r.d(t,{Z:function(){return x}});var n=r(59883),s="\ud800-\udfff",a="[\\u0300-\\u036f\\ufe20-\\ufe2f\\u20d0-\\u20ff]",i="\ud83c[\udffb-\udfff]",l="[^"+s+"]",c="(?:\ud83c[\udde6-\uddff]){2}",o="[\ud800-\udbff][\udc00-\udfff]",u="(?:"+a+"|"+i+")?",d="[\\ufe0e\\ufe0f]?",f="(?:\\u200d(?:"+[l,c,o].join("|")+")"+d+u+")*",m=RegExp(i+"(?="+i+")|(?:"+[l+a+"?",a,c,o,"["+s+"]"].join("|")+")"+(d+u+f),"g"),x=function(e){return(0,n.Z)(e)?e.match(m)||[]:e.split("")}},6670:function(e,t){"use strict";var r=/\s/;t.Z=function(e){for(var t=e.length;t--&&r.test(e.charAt(t)););return t}},88542:function(e,t,r){"use strict";r.d(t,{Z:function(){return c}});var n=r(53294),s=r(77934),a=r(59883),i=r(14955),l=function(e){e=(0,n.Z)(e);var t=(0,a.Z)(e)?(0,i.Z)(e):void 0,r=t?t[0]:e.charAt(0),l=t?(0,s.Z)(t,1).join(""):e.slice(1);return r.toUpperCase()+l},c=function(e){return l((0,n.Z)(e).toLowerCase())}},45391:function(e,t,r){"use strict";r.d(t,{Z:function(){return o}});var n=r(84639),s=r(48717),a=function(){return s.Z.Date.now()},i=r(26165),l=Math.max,c=Math.min,o=function(e,t,r){var s,o,u,d,f,m,x=0,p=!1,h=!1,v=!0;if("function"!=typeof e)throw TypeError("Expected a function");function j(t){var r=s,n=o;return s=o=void 0,x=t,d=e.apply(n,r)}function g(e){var r=e-m,n=e-x;return void 0===m||r>=t||r<0||h&&n>=u}function b(){var e,r,n,s=a();if(g(s))return N(s);f=setTimeout(b,(e=s-m,r=s-x,n=t-e,h?c(n,u-r):n))}function N(e){return(f=void 0,v&&s)?j(e):(s=o=void 0,d)}function y(){var e,r=a(),n=g(r);if(s=arguments,o=this,m=r,n){if(void 0===f)return x=e=m,f=setTimeout(b,t),p?j(e):d;if(h)return clearTimeout(f),f=setTimeout(b,t),j(m)}return void 0===f&&(f=setTimeout(b,t)),d}return t=(0,i.Z)(t)||0,(0,n.Z)(r)&&(p=!!r.leading,u=(h="maxWait"in r)?l((0,i.Z)(r.maxWait)||0,t):u,v="trailing"in r?!!r.trailing:v),y.cancel=function(){void 0!==f&&clearTimeout(f),x=0,s=m=o=f=void 0},y.flush=function(){return void 0===f?d:N(a())},y}},38813:function(e,t){"use strict";var r=Array.isArray;t.Z=r},55357:function(e,t,r){"use strict";var n=r(17996),s=r(96786);t.Z=function(e){return"symbol"==typeof e||(0,s.Z)(e)&&"[object Symbol]"==(0,n.Z)(e)}},26165:function(e,t,r){"use strict";var n=r(18216),s=r(84639),a=r(55357),i=0/0,l=/^[-+]0x[0-9a-f]+$/i,c=/^0b[01]+$/i,o=/^0o[0-7]+$/i,u=parseInt;t.Z=function(e){if("number"==typeof e)return e;if((0,a.Z)(e))return i;if((0,s.Z)(e)){var t="function"==typeof e.valueOf?e.valueOf():e;e=(0,s.Z)(t)?t+"":t}if("string"!=typeof e)return 0===e?e:+e;e=(0,n.Z)(e);var r=c.test(e);return r||o.test(e)?u(e.slice(2),r?2:8):l.test(e)?i:+e}},53294:function(e,t,r){"use strict";var n=r(4109);t.Z=function(e){return null==e?"":(0,n.Z)(e)}}},function(e){e.O(0,[7565,8415,7430,8516,1652,340,4007,2546,1283,3449,2578,8511,240,4421,2287,8961,7288,1565,3240,4656,3375,5289,1744],function(){return e(e.s=68310)}),_N_E=e.O()}]);